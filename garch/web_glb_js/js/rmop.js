var pics=new Array();
var count=0;
var i=0;
var ith=0;
var speed=1000;
var data="";
var kk;
var dateStr;
var filename="";
var total;                                                                                                                                                             
function preload(img){
     pics[count] = new Image();
     pics[count].src = img;
     count++;
}

function get_speed(frm){
  if(frm.elements["spd"].selectedIndex == 0) speed=1000;
  if(frm.elements["spd"].selectedIndex == 1) speed=100;
  if(frm.elements["spd"].selectedIndex == 2) speed=2000;
  return speed;
}
                                                                                                                                                             
function increse_i(){
   i++;
   return i;
}
                                                                                                                                                             
function anim(){
     if(i>=total){
       i=0;
     }
     document.my_image.src =  pics[i].src;
     window.setTimeout("increse_i(); anim()", speed);
}
                                                                                                                                                             
function show(i){
  ith=i;
  document.my_image.src=pics[ith].src;
}

function next(){
  ith=ith+1;
  if(ith >= total-1) ith=total-1;
   document.my_image.src=pics[ith].src;
}
                                                                                                                                                             
function prev(){
  ith=ith-1;
  if(ith < 0) ith=0;
   document.my_image.src=pics[ith].src;
}
                                                                                                                                                             
function rewind(){
  ith=0;
   document.my_image.src=pics[ith].src;
}
                                                                                                                                                             
function last(){
  ith=total-1;
   document.my_image.src=pics[ith].src;
}
                                                                                                                                                             
function openWin(url) {
  newWin=window.open(url);
}
                                                                                                                                                             
function reload(){
   open(this);
}

function load_image(frm){
     total = 15;
     count=0;
     for(k=0; k<total; k++){
       kk=24+k*24;
       data=kk+frm.reg.options[frm.reg.selectedIndex].value+'.png';
       filename="https://www.emc.ncep.noaa.gov/gmb/wx20cb/mmap/"+frm.dy.options[frm.dy.selectedIndex].value+frm.tz.options[frm.tz.selectedIndex].value+"/mmap_"+frm.dy.options[frm.dy.selectedIndex].value+frm.tz.options[frm.tz.selectedIndex].value+"_"+data;
       preload(filename);
     }
  show(0);
}


