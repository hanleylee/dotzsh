# Author: Hanley Lee
# Website: https://www.hanleylee.com
# GitHub: https://github.com/hanleylee
# License:  MIT License

# Commands and alias for JetBrains product

if ! command_exists jb; then
    return
fi

# ========== PyCharm ===========
function pycharm_pffile() { jb cur_file --product='PY'; }
function pycharm_pfdir() { dirname "$(pycharm_pffile)"; }
function pycharm_pfproj() { jb cur_project --product='PY'; }
# cd to the path of the directory of PyCharm's current editing file
function cdpycharm() { cd "$(pycharm_pfdir)" || return; }
function cdpycharm_file() { cd "$(pycharm_pfdir)" || return; }
function cdpycharm_proj() { cd "$(pycharm_pfproj)" || return; }

# ========== Idea ===========
function idea_pffile() { jb cur_file --product='IC'; }
function idea_pfdir() { dirname "$(idea_pffile)"; }
function idea_pfproj() { jb cur_project --product='IC'; }
function cdidea() { cd "$(idea_pfdir)" || return; }
function cdidea_file() { cd "$(idea_pfdir)" || return; }
function cdidea_proj() { cd "$(idea_pfproj)" || return; }

# ========== RustRover ===========
function rustrover_pffile() { jb cur_file --product='RR'; }
function rustrover_pfdir() { dirname "$(rustrover_pffile)"; }
function rustrover_pfproj() { jb cur_project --product='RR'; }
function cdrustrover() { cd "$(rustrover_pfdir)" || return; }
function cdrustrover_file() { cd "$(rustrover_pfdir)" || return; }
function cdrustrover_proj() { cd "$(rustrover_pfproj)" || return; }

# ========== CLion ===========
function clion_pffile() { jb cur_file --product='CL'; }
function clion_pfdir() { dirname "$(clion_pffile)"; }
function clion_pfproj() { jb cur_project --product='CL'; }
function cdclion() { cd "$(clion_pfdir)" || return; }
function cdclion_file() { cd "$(clion_pfdir)" || return; }
function cdclion_proj() { cd "$(clion_pfproj)" || return; }
