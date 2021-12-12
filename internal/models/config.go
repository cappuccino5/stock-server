
package models

import (
	"github.com/cappuccino5/skeleton/server"
)

var GlobalConfig models.Config

type Config struct {
	server.CommonConfig
}
