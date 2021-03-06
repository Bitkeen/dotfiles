# Please refer to commands_full.py for all the default commands and a
# complete documentation.  Do NOT add them all here, or you may end up
# with defunct commands when upgrading ranger.

import os
import os.path
import subprocess
from functools import partial

from ranger.api.commands import Command
from ranger.core.loader import CommandLoader


class compress(Command):
    """
    :compress

    Compress marked files to current directory.
    """
    def execute(self):
        cwd = self.fm.thisdir
        marked_files = cwd.get_selection()

        if not marked_files:
            return

        def refresh(_):
            cwd = self.fm.get_directory(original_path)
            cwd.load_content()

        original_path = cwd.path
        parts = self.line.split()
        au_flags = parts[1:]

        descr = 'compressing files in: ' + os.path.basename(parts[1])
        obj = CommandLoader(args=['apack'] + au_flags + \
                [os.path.relpath(f.path, cwd.path) for f in marked_files], descr=descr)

        obj.signal_bind('after', refresh)
        self.fm.loader.add(obj)

    def tab(self):
        """Complete with current folder name."""
        extension = ['.zip', '.tar.gz', '.rar', '.7z']
        return ['compress ' + os.path.basename(self.fm.thisdir.path) + ext for ext in extension]


class empty_trash(Command):
    """
    :empty_trash

    Empty the trash directory with 'gio trash --empty'.
    """
    def execute(self):
        self.fm.ui.console.ask(
            'Clear trash? (y/N)',
            partial(self._question_callback),
            ('n', 'N', 'y', 'Y'),
        )

    def _question_callback(self, answer):
        if answer in ('y', 'Y'):
            self.fm.run('gio trash --empty')


class extract_here(Command):
    """
    :extract_here

    Extract copied files to current directory.
    Archive extraction is done by copying (yy) one or more archive
    files and then executing :extract_here on the desired directory.
    """
    def execute(self):
        copied_files = tuple(self.fm.copy_buffer)

        if not copied_files:
            return

        def refresh(_):
            cwd = self.fm.get_directory(original_path)
            cwd.load_content()

        one_file = copied_files[0]
        cwd = self.fm.thisdir
        original_path = cwd.path
        au_flags = ['-X', cwd.path]
        au_flags += self.line.split()[1:]
        au_flags += ['-e']

        self.fm.copy_buffer.clear()
        self.fm.cut_buffer = False
        if len(copied_files) == 1:
            descr = 'extracting: ' + os.path.basename(one_file.path)
        else:
            descr = 'extracting files from: ' + os.path.basename(one_file.dirname)
        obj = CommandLoader(args=['aunpack'] + au_flags \
                + [f.path for f in copied_files], descr=descr)

        obj.signal_bind('after', refresh)
        self.fm.loader.add(obj)


class fzf_select(Command):
    """
    :fzf_select

    Find a file using fzf.
    With a prefix argument select only directories.

    See:
    https://github.com/junegunn/fzf
    https://github.com/ranger/ranger/wiki/Custom-Commands#fzf-integration
    """
    def execute(self):
        if self.quantifier:
            # match only directories
            command = "find -L . \( -path '*/\.*' -o -fstype 'dev' -o -fstype 'proc' \) -prune \
            -o -type d -print 2> /dev/null | sed 1d | cut -b3- | fzf +m"
        else:
            # match files and directories
            command = "find -L . \( -path '*/\.*' -o -fstype 'dev' -o -fstype 'proc' \) -prune \
            -o -print 2> /dev/null | sed 1d | cut -b3- | fzf +m"
        fzf = self.fm.execute_command(command, universal_newlines=True, stdout=subprocess.PIPE)
        stdout, _ = fzf.communicate()
        if fzf.returncode == 0:
            fzf_file = os.path.abspath(stdout.rstrip('\n'))
            if os.path.isdir(fzf_file):
                self.fm.cd(fzf_file)
            else:
                self.fm.select_file(fzf_file)


class fzf_alt_c(Command):
    """
    :fzf_cd

    Same as Alt+C in shell.
    """

    def execute(self):
        cmd_varname = 'FZF_ALT_C_COMMAND'
        fzf_flags = (
            '--reverse'
            ' --preview-window="nohidden"'
        )

        try:
            prev_shell = os.environ['SHELL']
        except KeyError:
            self.fm.notify('Error: SHELL variable is missing', bad=True)
            return

        try:
            command = f'{os.environ[cmd_varname]} | fzf {fzf_flags}'
        except KeyError:
            self.fm.notify(f'Error: {cmd_varname} variable is missing', bad=True)
            return

        def _execute():
            fzf = self.fm.execute_command(
                command, universal_newlines=True, stdout=subprocess.PIPE)
            stdout, _ = fzf.communicate()
            if fzf.returncode == 0:
                choice = os.path.abspath(stdout.rstrip('\n'))
                self.fm.cd(choice)

        # Previews break when ranger is launched with the
        # `ranger-shell` script, swapping `SHELL` variable is
        # a workaround.
        os.environ['SHELL'] = '/bin/sh'
        try:
            _execute()
        finally:
            os.environ['SHELL'] = prev_shell


class fzf_mounted(Command):
    """
    :fzf_mounted

    Go to a mounted partition chosen with fzf.
    Pass `-t` flag to open the selected directory in a new tab.
    """
    def execute(self):
        command = 'fzf-mounted'
        method = self.fm.tab_new if '-t' in self.args else self.fm.cd

        fzf = self.fm.execute_command(command,
                                      universal_newlines=True,
                                      stdout=subprocess.PIPE)
        stdout, _ = fzf.communicate()
        if fzf.returncode == 0:
            fzf_dir = os.path.abspath(stdout.rstrip('\n'))
            method(path=fzf_dir)


class error(Command):
    """
    :error <message>

    Print an error message.
    """
    def execute(self):
        self.fm.notify(' '.join(self.args[1:]), bad=True)
