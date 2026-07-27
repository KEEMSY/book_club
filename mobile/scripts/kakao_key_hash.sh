#!/usr/bin/env bash
# Kakao Android key hash 산출 (BC-26).
#
# 카카오 로그인은 요청의 android_key_hash 가 개발자 콘솔에 등록된 값과 다르면
# KOE101 을 반환한다. 디버그 keystore 와 릴리즈 keystore 는 서로 다른 해시를
# 만들므로 콘솔에 둘 다 등록해야 한다.
#
# 사용법:
#   ./mobile/scripts/kakao_key_hash.sh                 # 디버그 keystore
#   ./mobile/scripts/kakao_key_hash.sh <keystore> <alias>
#
# 릴리즈 keystore 비밀번호는 프롬프트로 입력받는다 (인자로 넘기면 셸 히스토리에
# 남으므로 받지 않는다).

set -euo pipefail

DEBUG_KEYSTORE="${HOME}/.android/debug.keystore"

keystore="${1:-${DEBUG_KEYSTORE}}"
alias_name="${2:-androiddebugkey}"

if [[ ! -f "${keystore}" ]]; then
    echo "keystore 를 찾을 수 없습니다: ${keystore}" >&2
    if [[ "${keystore}" == "${DEBUG_KEYSTORE}" ]]; then
        echo "안드로이드 앱을 한 번 빌드하면 디버그 keystore 가 생성됩니다." >&2
    fi
    exit 1
fi

if [[ "${keystore}" == "${DEBUG_KEYSTORE}" ]]; then
    store_pass="android"   # AOSP 고정 디버그 비밀번호
else
    read -r -s -p "keystore 비밀번호: " store_pass
    echo
fi

hash="$(keytool -exportcert -alias "${alias_name}" -keystore "${keystore}" \
    -storepass "${store_pass}" 2>/dev/null | openssl sha1 -binary | openssl base64)"

echo "keystore : ${keystore}"
echo "alias    : ${alias_name}"
echo "key hash : ${hash}"
echo
echo "developers.kakao.com → 내 애플리케이션 → 앱 설정 → 플랫폼 → Android 에 등록하세요."
