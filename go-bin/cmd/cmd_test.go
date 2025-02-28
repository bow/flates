package cmd

import (
	"bytes"
	"fmt"
	"os"
	"strings"
	"testing"

	"github.com/spf13/cobra"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"

	"github.com/bow/exe/internal"
)

func TestNoArgs(t *testing.T) {
	stdout, stderr, err := execCommand(nil)
	require.NoError(t, err)

	assert.Empty(t, stderr)
	assert.Contains(t, stdout, `Use "exe [command] --help" for more information`)
}

func TestVersionOk(t *testing.T) {
	stdout, stderr, err := execCommand([]string{"version"})
	require.NoError(t, err)

	assert.Empty(t, stderr)
	assert.Contains(t, stdout, fmt.Sprintf("Version    : %s", internal.Version()))
}

// execCommand executes the command for testing.
func execCommand(args []string) (stdout string, stderr string, err error) {
	cmd, outb, errb := newCommand()
	cmd.SetArgs(args)

	err = cmd.Execute()

	return outb.String(), errb.String(), err
}

// newCommand creates new cobra command for testing. It also returns the buffers that
// capture the command's stdout and stderr, respectively.
func newCommand() (cmd *cobra.Command, outb *bytes.Buffer, errb *bytes.Buffer) {
	cmd = New()

	outb = bytes.NewBufferString("")
	cmd.SetOut(outb)

	errb = bytes.NewBufferString("")
	cmd.SetErr(errb)

	return cmd, outb, errb
}

// createTestDir creates a temporary directory for testing. It also registers a cleanup function for
// removing the directory automatically after testing. The created directory is named after the
// given `dir` value, appended with a random value to guarantee uniqueness. If `dir` is empty, the
// t.Name() (the test name) will be used instead.
func createTestDir(t *testing.T, dir string) string {
	t.Helper()

	if dir == "" {
		dir = t.Name()
	}

	// os.MkdirTemp does not work if the given patten contains path separators, so we replace
	// them with hyphens.
	tempDir, err := os.MkdirTemp("", fmt.Sprintf("%s-*", strings.ReplaceAll(dir, "/", "-")))
	require.NoError(t, err)

	// Create and register cleanup function.
	cleanup := func() {
		if err := os.RemoveAll(tempDir); err != nil {
			panic(fmt.Sprintf("failed to remove test directory for %q: %s", t.Name(), err))
		}
		if _, err := os.Stat(tempDir); !os.IsNotExist(err) {
			panic(fmt.Sprintf("failed to ensure removal of test directory for %q: %s", t.Name(), err))
		}
	}
	t.Cleanup(cleanup)

	return tempDir
}
