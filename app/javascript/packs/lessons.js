window.addLessonTagField = function addLessonTagField(lessonId) {
  //create Date object
  var date = new Date();

  //get number of milliseconds since midnight Jan 1, 1970
  //and use it for key
  var mSec = date.getTime();

  //Replace 0 with milliseconds
  idAttribut = "tagFieldId".replace("0", mSec);
  nameAttribut = "tag_names[0]".replace("0", mSec);

  //create <li> tag
  var li = document.createElement("li");

  //create input for Kind, set it's type, id and name attribute,
  //and append it to <li> element
  var inputKind = document.createElement("INPUT");
  inputKind.setAttribute("type", "text");
  inputKind.setAttribute("id", idAttribut);
  inputKind.setAttribute("name", nameAttribut);
  inputKind.setAttribute("class", "input_tags_buttons");
  li.appendChild(inputKind);

  //add created <li> element with its child elements
  //(label and input) to myList (<ul>) element
  document.getElementById(`myLessonList${lessonId}`).appendChild(li);
};
