##
## cp.tcl --
##
##     The compiler module.   
##
## Copyright (C) 2002 Stacho Mudrak
## 
## $Date: $
## $RCSfile: $
## $Revision: $
##
## -------------------------------------------------------------------- 
## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 2 of the License, or
## any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
## 
## You should have received a copy of the GNU General Public License
## along with this program; if not, write to the Free Software
## Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
## --------------------------------------------------------------------


xth_app_create cp "Compiler" 
xth_ctrl_add cp stp "Settings"
xth_ctrl_add cp dat "Survey structure"
xth_ctrl_add cp info "Survey info"
xth_ctrl_add cp ms "Map structure"
xth_ctrl_finish cp

# create config editor
set xth(cp,editor) $xth(gui,cp).af.apps.ed
frame $xth(cp,editor)
set txb $xth(cp,editor)
text $txb.txt -wrap none -font $xth(gui,efont) \
  -bg $xth(gui,ecolorbg) \
  -fg $xth(gui,ecolorfg) -insertbackground $xth(gui,ecolorfg) \
  -relief sunken -state disabled \
  -selectbackground $xth(gui,ecolorselbg) \
  -selectforeground $xth(gui,ecolorselfg) \
  -selectborderwidth 0 \
  -yscrollcommand "$txb.sv set" \
  -xscrollcommand "$txb.sh set" 
if {$xth(gui,text_undo)} {
    $txb.txt configure -undo 1 -maxundo -1
}
scrollbar $txb.sv -orient vert  -command "$txb.txt yview" \
  -takefocus 0 -width $xth(gui,sbwidth) -borderwidth $xth(gui,sbwidthb)
scrollbar $txb.sh -orient horiz  -command "$txb.txt xview" \
  -takefocus 0 -width $xth(gui,sbwidth) -borderwidth $xth(gui,sbwidthb)
grid columnconf $txb 0 -weight 1
grid rowconf $txb 0 -weight 1
grid $txb.txt -column 0 -row 0 -sticky news
grid $txb.sv -column 1 -row 0 -sticky news
grid $txb.sh -column 0 -row 1 -sticky news
bind $txb.txt <Control-Key-x> "tk_textCut $txb.txt"
bind $txb.txt <Control-Key-c> "tk_textCopy $txb.txt"
bind $txb.txt <Control-Key-v> "tk_textPaste $txb.txt"
bind $txb.txt <Control-Key-z> "catch {$txb.txt edit undo}"
bind $txb.txt <Control-Key-y> "catch {$txb.txt edit redo}"

if {$xth(gui,bindinsdel)} {
  bind $txb.txt <Shift-Key-Delete> "tk_textCut $txb.txt"
  bind $txb.txt <Control-Key-Insert> "tk_textCopy $txb.txt"
  bind $txb.txt <Shift-Key-Insert> "tk_textPaste $txb.txt"
#  catch {
#    bind $txb.txt <Shift-Key-KP_Decimal> "tk_textCut $txb.txt"
#    bind $txb.txt <Control-Key-KP_Insert> "tk_textCopy $txb.txt"
#    bind $txb.txt <Shift-Key-KP_0> "tk_textPaste $txb.txt"
#  }
}

# nechame tab, return originalny
#if {[info exists xth(gui,te)]} {
#  bind $txb.txt <Control-Key-a> "xth_te_text_select_all %W"
#  bind $txb.txt <Control-Key-i> "xth_te_text_auto_indent %W"
  bind $txb.txt <Tab> $xth(te,bind,text_tab)
#  bind $txb.txt <Return> $xth(te,bind,text_return)
#} else {
#  bind $txb.txt <Tab> $xth(gui,bind,text_tab)
  bind $txb.txt <Return> $xth(gui,bind,text_return)
#}


# create log window
set xth(cp,log) $xth(gui,cp).af.apps.log
frame $xth(cp,log)
set txb $xth(cp,log)
text $txb.txt -wrap none -font $xth(gui,efont) \
  -bg $xth(gui,ecolorbg) \
  -fg $xth(gui,ecolorfg) -insertbackground $xth(gui,ecolorfg) \
  -relief sunken -state disabled \
  -selectbackground $xth(gui,ecolorselbg) \
  -selectforeground $xth(gui,ecolorselfg) \
  -selectborderwidth 0 \
  -yscrollcommand "$txb.sv set" \
  -xscrollcommand "$txb.sh set" 
scrollbar $txb.sv -orient vert  -command "$txb.txt yview" \
  -takefocus 0 -width $xth(gui,sbwidth) -borderwidth $xth(gui,sbwidthb)
scrollbar $txb.sh -orient horiz  -command "$txb.txt xview" \
  -takefocus 0 -width $xth(gui,sbwidth) -borderwidth $xth(gui,sbwidthb)
grid columnconf $txb 0 -weight 1
grid rowconf $txb 0 -weight 1
grid $txb.txt -column 0 -row 0 -sticky news
grid $txb.sv -column 1 -row 0 -sticky news
grid $txb.sh -column 0 -row 1 -sticky news
bind $txb.txt <Control-Key-x> "tk_textCut $txb.txt"
bind $txb.txt <Control-Key-c> "tk_textCopy $txb.txt"
bind $txb.txt <Control-Key-v> "tk_textPaste $txb.txt"

if {$xth(gui,bindinsdel)} {
  bind $txb.txt <Shift-Key-Delete> "tk_textCut $txb.txt"
  bind $txb.txt <Control-Key-Insert> "tk_textCopy $txb.txt"
  bind $txb.txt <Shift-Key-Insert> "tk_textPaste $txb.txt"
#  catch {
#    bind $txb.txt <Shift-Key-KP_Decimal> "tk_textCut $txb.txt"
#    bind $txb.txt <Control-Key-KP_Insert> "tk_textCopy $txb.txt"
#    bind $txb.txt <Shift-Key-KP_0> "tk_textPaste $txb.txt"
#  }
}

xth_status_bar cp $txb.txt "Therion log file."


# pack editor and log widow
grid columnconf $xth(gui,cp).af.apps 0 -weight 1
grid rowconf $xth(gui,cp).af.apps 0 -weight 1
grid rowconf $xth(gui,cp).af.apps 1 -weight 1
grid $xth(cp,editor) -column 0 -row 0 -sticky news
grid $xth(cp,log) -column 0 -row 1 -sticky news

# create setup control
Label $xth(ctrl,cp,stp).wl -text "Working directory" -anchor w -font $xth(gui,lfont) -state disabled
xth_status_bar cp $xth(ctrl,cp,stp).wl "Working directory path."
Entry $xth(ctrl,cp,stp).we -font $xth(gui,lfont) -state disabled \
  -editable off -textvariable xth(cp,fpath)
xth_status_bar cp $xth(ctrl,cp,stp).we "Working directory path."

Label $xth(ctrl,cp,stp).fl -text "Configuration file" -anchor w -font $xth(gui,lfont) -state disabled
xth_status_bar cp $xth(ctrl,cp,stp).fl "Configuration file name."
Entry $xth(ctrl,cp,stp).fe -font $xth(gui,lfont) -state disabled \
  -editable off -textvariable xth(cp,fname)
xth_status_bar cp $xth(ctrl,cp,stp).fe "Configuration file name."

Label $xth(ctrl,cp,stp).optl -text "Command line options" -anchor w -font $xth(gui,lfont) -state disabled
xth_status_bar cp $xth(ctrl,cp,stp).optl "Therion command line options."
Entry $xth(ctrl,cp,stp).opte -font $xth(gui,lfont) -state disabled \
  -textvariable xth(cp,opts)
xth_status_bar cp $xth(ctrl,cp,stp).opte "Therion command line options."

Button $xth(ctrl,cp,stp).go -text "Compile" -anchor center -font $xth(gui,lfont) \
  -state disabled -command {xth_cp_compile} -width 4
Label $xth(ctrl,cp,stp).gores -text "" -anchor center -font $xth(gui,lfont) \
  -state disabled -width 4 -relief sunken
set xth(cp,resfg) [$xth(ctrl,cp,stp).gores cget -fg]
set xth(cp,resbg) [$xth(ctrl,cp,stp).gores cget -bg]
xth_status_bar cp $xth(ctrl,cp,stp).go "Run therion."

grid columnconf $xth(ctrl,cp,stp) 0 -weight 1
grid columnconf $xth(ctrl,cp,stp) 1 -weight 1
grid $xth(ctrl,cp,stp).wl -row 0 -column 0 -columnspan 2 -sticky news
grid $xth(ctrl,cp,stp).we -row 1 -column 0 -columnspan 2 -sticky news
grid $xth(ctrl,cp,stp).fl -row 2 -column 0 -columnspan 2 -sticky news
grid $xth(ctrl,cp,stp).fe -row 3 -column 0 -columnspan 2 -sticky news
grid $xth(ctrl,cp,stp).optl -row 4 -column 0 -columnspan 2 -sticky news
grid $xth(ctrl,cp,stp).opte -row 5 -column 0 -columnspan 2 -sticky news
grid $xth(ctrl,cp,stp).go -row 6 -column 0 -sticky news
grid $xth(ctrl,cp,stp).gores -row 6 -column 1 -sticky ew

# create objects control
set clbox $xth(ctrl,cp,dat)
#### set sw [ScrolledWindow $clbox.sw -relief sunken -borderwidth 2]
scrollbar $clbox.sv -orient vert  -command "$clbox.t yview" \
  -takefocus 0 -width $xth(gui,sbwidth) -borderwidth $xth(gui,sbwidthb)
scrollbar $clbox.sh -orient horiz  -command "$clbox.t xview" \
  -takefocus 0 -width $xth(gui,sbwidth) -borderwidth $xth(gui,sbwidthb)
###set tr [Tree $sw.t -relief flat -height 16 -selectcommand xth_cp_data_tree_select]
set tr [Tree $clbox.t -relief flat -height 16 -selectcommand xth_cp_data_tree_select \
  -yscrollcommand "$clbox.sv set" \
  -xscrollcommand "$clbox.sh set"]
set xth(ctrl,cp,datrestore) {}
###$sw setwidget $tr
$tr bindText <Enter> xth_cp_data_tree_enter
$tr bindText <Leave> xth_cp_data_tree_leave
$tr bindText <Double-ButtonPress-1> xth_cp_data_tree_double_click
$tr bindImage <Enter> xth_cp_data_tree_enter
$tr bindImage <Leave> xth_cp_data_tree_leave
$tr bindImage <Double-ButtonPress-1> xth_cp_data_tree_double_click
### pack $sw -side top -expand yes -fill both

grid columnconf $clbox 0 -weight 1
grid rowconf $clbox 0 -weight 1
grid $tr -column 0 -row 0 -sticky news
grid $clbox.sv -column 1 -row 0 -sticky news
grid $clbox.sh -column 0 -row 1 -sticky news


# init survey info
set txb $xth(ctrl,cp,info)
text $txb.txt -height 4 -wrap none -font $xth(gui,efont) \
  -bg $xth(gui,ecolorbg) \
  -fg $xth(gui,ecolorfg) -insertbackground $xth(gui,ecolorfg) \
  -relief sunken -state disabled \
  -selectbackground $xth(gui,ecolorselbg) \
  -selectforeground $xth(gui,ecolorselfg) \
  -selectborderwidth 0 \
  -yscrollcommand "$txb.sv set" \
  -xscrollcommand "$txb.sh set" 
scrollbar $txb.sv -orient vert  -command "$txb.txt yview" \
  -takefocus 0 -width $xth(gui,sbwidth) -borderwidth $xth(gui,sbwidthb)
scrollbar $txb.sh -orient horiz  -command "$txb.txt xview" \
  -takefocus 0 -width $xth(gui,sbwidth) -borderwidth $xth(gui,sbwidthb)
grid columnconf $txb 0 -weight 1
grid rowconf $txb 0 -weight 1
grid $txb.txt -column 0 -row 0 -sticky news
grid $txb.sv -column 1 -row 0 -sticky news
grid $txb.sh -column 0 -row 1 -sticky news
xth_status_bar me $txb.txt "Survey informations."
bind $txb.txt <Control-Key-x> "tk_textCut $txb.txt"
bind $txb.txt <Control-Key-c> "tk_textCopy $txb.txt"
bind $txb.txt <Control-Key-v> "tk_textPaste $txb.txt"

if {$xth(gui,bindinsdel)} {
  bind $txb.txt <Shift-Key-Delete> "tk_textCut $txb.txt"
  bind $txb.txt <Control-Key-Insert> "tk_textCopy $txb.txt"
  bind $txb.txt <Shift-Key-Insert> "tk_textPaste $txb.txt"
#  catch {
#    bind $txb.txt <Shift-Key-KP_Decimal> "tk_textCut $txb.txt"
#    bind $txb.txt <Control-Key-KP_Insert> "tk_textCopy $txb.txt"
#    bind $txb.txt <Shift-Key-KP_0> "tk_textPaste $txb.txt"
#  }
}



# create map structure control
set clbox $xth(ctrl,cp,ms)
###set sw [ScrolledWindow $clbox.sw -relief sunken -borderwidth 2]
scrollbar $clbox.sv -orient vert  -command "$clbox.t yview" \
  -takefocus 0 -width $xth(gui,sbwidth) -borderwidth $xth(gui,sbwidthb)
scrollbar $clbox.sh -orient horiz  -command "$clbox.t xview" \
  -takefocus 0 -width $xth(gui,sbwidth) -borderwidth $xth(gui,sbwidthb)
set tr [Tree $clbox.t -relief flat -height 16 \
  -yscrollcommand "$clbox.sv set" \
  -xscrollcommand "$clbox.sh set"]
set xth(ctrl,cp,msrestore) {}
###$sw setwidget $tr
$tr bindText <Enter> xth_cp_map_tree_enter
$tr bindText <Leave> xth_cp_map_tree_leave
$tr bindText <Double-ButtonPress-1> xth_cp_map_tree_double_click
$tr bindImage <Enter> xth_cp_map_tree_enter
$tr bindImage <Leave> xth_cp_map_tree_leave
$tr bindImage <Double-ButtonPress-1> xth_cp_map_tree_double_click
###pack $sw -side top -expand yes -fill both
grid columnconf $clbox 0 -weight 1
grid rowconf $clbox 0 -weight 1
grid $tr -column 0 -row 0 -sticky news
grid $clbox.sv -column 1 -row 0 -sticky news
grid $clbox.sh -column 0 -row 1 -sticky news






# load menu
$xth(cp,menu,file) add command -label "New" -command {} \
  -font $xth(gui,lfont) -underline 0 -state normal -command {xth_cp_new_file}
$xth(cp,menu,file) add command -label "Open" -underline 0 \
  -accelerator "$xth(gui,controlk)-o" -state normal \
  -font $xth(gui,lfont) -command {
    xth_cp_open_file {}
  }
$xth(cp,menu,file) add command -label "Save as" -underline 5 \
  -state disabled -font $xth(gui,lfont) -command xth_cp_save_as
$xth(cp,menu,file) add command -label "Close" -underline 0 \
  -accelerator "$xth(gui,controlk)-w"  -state disabled \
  -font $xth(gui,lfont) \
  -command xth_cp_close_file

set xth(cp,menu,edit) $xth(cp,menu).edit
menu $xth(cp,menu,edit) -tearoff 0
$xth(cp,menu) add cascade -label "Edit" -state disabled \
  -font $xth(gui,lfont) -menu $xth(cp,menu,edit) -underline 0
if {$xth(gui,text_undo)} {
  $xth(cp,menu,edit) add command -label "Undo" -font $xth(gui,lfont) \
    -accelerator "$xth(gui,controlk)-z" -command "xth_app_clipboard undo"
  $xth(cp,menu,edit) add command -label "Redo" -font $xth(gui,lfont) \
    -accelerator "$xth(gui,controlk)-y" -command "xth_app_clipboard redo"
  $xth(cp,menu,edit) add separator
}
$xth(cp,menu,edit) add command -label "Cut" -font $xth(gui,lfont) \
  -accelerator "$xth(gui,controlk)-x" -command "xth_app_clipboard cut"
$xth(cp,menu,edit) add command -label "Copy" -font $xth(gui,lfont) \
  -accelerator "$xth(gui,controlk)-c" -command "xth_app_clipboard copy"
$xth(cp,menu,edit) add command -label "Paste" -font $xth(gui,lfont) \
  -accelerator "$xth(gui,controlk)-v" -command "xth_app_clipboard paste"

set xth(cp,fopen) 0
set xth(cp,cursor) 1.0
set xth(cp,fname) ""
set xth(cp,opts) ""
set xth(cp,fpath) ""

xth_ctrl_minimize cp dat
xth_ctrl_minimize cp info
xth_ctrl_minimize cp ms

set xth(ctrl,cp,datlist) {}
set xth(ctrl,cp,maplist) {}
