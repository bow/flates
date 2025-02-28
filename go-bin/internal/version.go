package internal

// All values declared here are meant to be overwritten at compile time.
var gitCommit, version string

// GitCommit returns the commit hash at which the binary was compiled.
func GitCommit() string {
	return gitCommit
}

// Version returns the application version.
func Version() string {
	return version
}
