package main

import (
	"context"
	"fmt"
	"os"

	"github.com/bow/exe/cmd"
)

func main() {
	ctx := context.Background()
	command := cmd.New()

	if err := command.ExecuteContext(ctx); err != nil {
		fmt.Fprintf(os.Stderr, "Error: %s\n", err)
		os.Exit(1)
	}
}
