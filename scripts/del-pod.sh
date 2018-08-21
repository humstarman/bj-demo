#!/bin/bash
show_help () {
DEFAULT_NAMESPACE=default
cat << USAGE
usage: $0 [ -n POD-NAME ] [ -s NAMESPACE ]
    -n : Specify the name of the pod to delete. 
    -s : Specify the namespace to work in. 
         If not specified, use "${DEFAULT_NAMESPACE}" by default.
USAGE
exit 0
}
# Get Opts
while getopts "hn:s:" opt; do # 选项后面的冒号表示该选项需要参数
    case "$opt" in
    h)  show_help
        ;;
    n)  NAME=$OPTARG
        ;;
    s)  NAMESPACE=$OPTARG
        ;;
    ?)  # 当有不认识的选项的时候arg为?
        echo "unkonw argument"
        exit 1
        ;;
    esac
done
[ -z "$*" ] && show_help
chk_var () {
if [ -z "$2" ]; then
  echo "$(date -d today +'%Y-%m-%d %H:%M:%S') - [ERROR] - no input for \"$1\", try \"$0 -h\"."
  sleep 3
  exit 1
fi
}
chk_var -n $NAME
NAMESPACE=${NAMESPACE:-"${DEFAULT_NAMESPACE}"}
POD=$(kubectl get po -n ${NAMESPACE} | grep ${NAME} | awk -F ' ' '{print $1}')
[ -z "${POD}" ] || kubectl -n ${NAMESPACE} delete pod ${POD}
