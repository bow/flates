package cmd

import (
	"github.com/spf13/cobra"

	"github.com/bow/exe/internal"
)

// New creates a new command along with its command-line flags.
func New() *cobra.Command {

	command := cobra.Command{
		Use:                internal.AppName(),
		Short:              "Binary description",
		SilenceUsage:       true,
		SilenceErrors:      true,
		DisableSuggestions: true,
		CompletionOptions:  cobra.CompletionOptions{DisableDefaultCmd: true},
		PersistentPreRunE: func(_ *cobra.Command, _ []string) error {
			return nil
		},
	}

	command.AddCommand(newVersionCommand())

	return &command
}
