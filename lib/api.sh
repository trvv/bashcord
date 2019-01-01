api:init() {
    API_BASE="${1}"
    API_TOKEN="${2}"
    API_AUTH="Authorization: ${API_TOKEN}"
    API_BOT_URL="${3}"
    API_BOT_VER="${4}"
    API_AGENT="DiscordBot (${API_BOT_URL}, ${API_BOT_VER})"
}

api:request() {
    url="${API_BASE}${2}"
    log debug "${1} ${2}"
    exec 3>&1
    err="$(curl -w '%{http_code}' -o >(cat >&3) -X "${1}" -s \
        -H "${API_AUTH}" -A "${API_AGENT}" "${API_BASE}${2}" $([ -n "${3}" ] \
        && echo "-d \"${3}\" -H \"applications/json\""))"
    case "${err}" in
        200) t="OK";;
        201) t="CREATED";;
        204) t="NO CONTENT";;
        304) t="NOT MODIFIED";;
        400) t="BAD REQUEST";;
        401) t="UNAUTHORIZED";;
        403) t="FORBIDDEN";;
        404) t="NOT FOUND";;
        405) t="METHOD NOT ALOWED";;
        429) t="TOO MANY REQUESTS";;
        502) t="GATEWAY UNAVAILABLE";;
        5*)  t="SERVER ERROR";;
    esac
    log debug "${err} (${t})"
    return ${err}
}

api:get() {
    map "$(api:request GET "${1}")" ${2-REPLY}
}

source "api/auditlog.sh"
source "api/channel.sh"
source "api/emoji.sh"
source "api/guild.sh"
source "api/user.sh"
source "api/voice.sh"
source "api/webhook.sh"
