# Override your default settings for the Production environment here.
#
# Example:
#   configatron.file.storage = :s3

configatron.stripe do |s|
  s.secret_key      = "sk_live_6zijLEFVjfDx1Sb7rPqXDmAD"
  s.publishable_key = "pk_live_M6YV7tsmI7rK8riMyhdkndBm"
end
