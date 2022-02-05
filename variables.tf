# Define the module's input below
variable "secrets" {
  type    = any
  default = {}
}

variable "tags" {
  type    = map(any)
  default = {}
}
