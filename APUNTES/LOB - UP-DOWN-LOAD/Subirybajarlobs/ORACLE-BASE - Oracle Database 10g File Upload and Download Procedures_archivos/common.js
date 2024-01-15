function RollGif(currentItem)
{
  var sGif = FindObj(currentItem);
  sGif = sGif.src;
  if (sGif.indexOf("Roll") > 0)
    document[currentItem].src = sGif.substring(0, sGif.length - 8) + ".gif";
  else
    document[currentItem].src = sGif.substring(0, sGif.length - 4) + "Roll.gif";
}

function switchMenuClass(currentItem)
{
  if (currentItem.className == "menuOff")
  {
    currentItem.className = "menuOn";
    currentItem.children.tags('A')[0].className = "menuOn";
  }
  else
  {
    currentItem.className = "menuOff";
    currentItem.children.tags('A')[0].className = "menuOff";
  }
}

function menuClick(sURL)
{
  window.location = sURL;
}

function FindObj(n, d) {
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length){
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=FindObj(n,d.layers[i].document); return x;
}

function SetSelectValue(sItem, sOption)
{
  var oItem = FindObj(sItem);
  var iOpt  = oItem.length;
  for (i=0; i<iOpt; i++)
    if (oItem.options[i].value == sOption) oItem.options[i].selected = true;
}

function GetSelectValue(sItem)
{
  var oItem = FindObj(sItem);
  return oItem.options[oItem.selectedIndex].value
}
