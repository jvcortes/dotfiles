
function use_vault () {
	env="$1"
	case $env in
		"non-prod")
			export VAULT_ADDR="https://vault-nonprod.smileco.cloud:8200"
			echo "Using Vault address $VAULT_ADDR"
			;;
		"prod")
			export VAULT_ADDR="https://vault-prod.smileco.cloud:8200"
			echo "Using Vault address $VAULT_ADDR"
			;;
		*)
			echo "Invalid environment."
	esac
}


