package internal

import (
	"fmt"
	"strings"
)

// AppName returns the application name.
func AppName() string {
	return "exe"
}

// AppHomepage returns the application homepage.
func AppHomepage() string {
	return "https://github.com/bow/exe"
}

// EnvKey returns the environment variable key for configuration.
func EnvKey(key string) string {
	if key == "" {
		return envPrefix()
	}
	return fmt.Sprintf("%s_%s", envPrefix(), strings.ToUpper(strings.ReplaceAll(key, "-", "_")))
}

// Banner shows the application name as ASCII art.
func Banner() string {
	return `  ___  _  _____
 / _ \| |/_/ _ \
/  __/>  </  __/
\___/_/|_|\___/
`
}

// envPrefix returns the environment variable prefix for configuration.
func envPrefix() string {
	return strings.ToUpper(AppName())
}
