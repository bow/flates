package cmd

import (
	"context"
	"fmt"
	"io"
	"strings"

	"github.com/spf13/cobra"
	"github.com/spf13/viper"

	"github.com/bow/exe/internal"
)

func newViper(cmdName string) *viper.Viper {
	v := viper.New()
	v.SetEnvPrefix(internal.EnvKey(cmdName))
	v.AutomaticEnv()
	v.SetEnvKeyReplacer(strings.NewReplacer("-", "_"))
	return v
}

type ctxKey string

func toCmdContext(cmd *cobra.Command, key string, value any) {
	ctx := context.WithValue(cmd.Context(), ctxKey(key), value)
	cmd.SetContext(ctx)
}

func fromCmdContext[T any](cmd *cobra.Command, key string) (T, error) {
	var zero T
	val, ok := cmd.Context().Value(ctxKey(key)).(T)
	if !ok {
		return zero, fmt.Errorf("can not retrieve %T value %[1]q from command context", key)
	}
	return val, nil
}

// showBanner prints the application banner to the given writer.
func showBanner(w io.Writer) {
	fmt.Fprintf(w, "%s\n", internal.Banner())
}
