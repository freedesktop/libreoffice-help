/* -*- Mode: C++; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- */
/*
 * This file is part of the LibreOffice project.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

// Pagination and fuzzy search
var url = document.URL;
var moduleRegex = new RegExp('text\\/(\\w+)\\/');
var regexArray = moduleRegex.exec(url);
var currentModule = null;
// get the module name from the URL and remove the first character,
// but first deal with snowflake Base
if(url.indexOf('explorer/database/') !== -1) {
    currentModule = 'BASE';
} else {
    currentModule = regexArray[1].toUpperCase().substring(1);
}
var results = null;
var fullLinkified = '';
var modules = ['CALC', 'WRITER', 'IMPRESS', 'DRAW', 'BASE', 'MATH', 'CHART', 'BASIC', 'SHARED'];
var indexkids = function() { document.getElementsByClassName("index")[0].children; };
// if user is not on a shared category page, limit the index to the current module + shared
if(currentModule !== 'HARED') {
    bookmarks = bookmarks.filter(function(obj) {
            return obj['app'] === currentModule || obj['app'] === 'SHARED';
        });
}
bookmarks.forEach(function(obj) {
            fullLinkified += '<a href="' + obj['url'] + '" class="' + obj['app'] + '">' + obj['text'] + '</a>';
        });
function fullList() {
    document.getElementsByClassName("index")[0].innerHTML = fullLinkified;
    Paginator(document.getElementsByClassName("index")[0]);
    addIds();
}
// add id to the first items of each category in the index. CSS ::before rule adds the heading text
function addIds() {
    for (var i = 0, len = indexkids.length; i < len; i++) {
        indexkids[i].removeAttribute("id");
    }
    modules.forEach(function(module) {
        var moduleHeader = document.getElementsByClassName(module)[0];
        if (typeof moduleHeader !== 'undefined') {
            moduleHeader.setAttribute("id", module);
        }
    });
}
// render the unfiltered index list on page load
fullList();
// filter the index list based on search field input
var search = document.getElementById('search-bar');
var filter = function() {
    var target = search.value.trim();
    if (target.length < 1) {
        fullList();
        return;
    }
    results = fuzzysort.go(target, bookmarks, {threshold: -15000, key:'text'});
    var filtered = '';
    results.forEach(function(result) {
        filtered += '<a href="' + result.obj['url'] + '" class="' + result.obj['app'] + '">' + fuzzysort.highlight(result) + '</a>';
    });
    document.getElementsByClassName("index")[0].innerHTML = filtered;
    Paginator(document.getElementsByClassName("index")[0]);
    addIds();
};
function debounce(fn, wait) {
    var timeout;
    return function() {
        clearTimeout(timeout);
        timeout = setTimeout(function() {
            fn.apply(this, arguments);
        }, (wait || 150));
    };
}
search.addEventListener('keyup', debounce(filter, 100));
// copy useful content to clipboard on mouse click
var copyable = document.getElementsByClassName("input");
for (var i = 0, len = copyable.length; i < len; i++) {
    (function() {
        var item = copyable[i];

        function changeColor(item, color, colorToChangeBackTo) {
            item.style.backgroundColor = color;
            setTimeout(function() {
                item.style.backgroundColor = colorToChangeBackTo;
            }, 150);
        }
        item.onclick = function() {
            document.execCommand("copy");
            changeColor(item, "#18A303", "transparent");
        };
        item.addEventListener("copy", function(event) {
            event.preventDefault();
            if (event.clipboardData) {
                event.clipboardData.setData("text/plain", item.textContent);
            }
        });
    }());
}
// auto-expand contents per subitem
var pathname = window.location.pathname;
var pathRegex = /text\/.*\.html$/;
var linkIndex = 0;
var contentMatch = pathname.match(pathRegex);
function linksMatch(content) {
    var linkMatch = new RegExp(content);
    var links = document.getElementById("Contents").getElementsByTagName("a");
    for (var i = 0, len = links.length; i < len; i++) {
        if (links[i].href.match(linkMatch)) {
            return i;
        }
    }
}
linkIndex = linksMatch(contentMatch);
if (typeof linkIndex !== "undefined") {
    var current = document.getElementById("Contents").getElementsByTagName("a")[linkIndex];
    var cItem = current.parentElement;
    var parents = [];
    while (cItem.parentElement && !cItem.parentElement.matches("#Contents") && parents.indexOf(cItem.parentElement) == -1) {
        parents.push(cItem = cItem.parentElement);
    }
    var liParents = [].filter.call(parents, function(item) {
        return item.matches("li");
    });
    for (var i = 0, len = liParents.length; i < len; i++) {
        var input = liParents[i].querySelectorAll(':scope > input');
        document.getElementById(input[0].id).checked = true;
    }
    current.classList.add('contents-current');
}
/* vim:set shiftwidth=4 softtabstop=4 expandtab cinoptions=b1,g0,N-s cinkeys+=0=break: */
