/**
* -----------------------------------------------------------------------------
*
*  Config jsx
*
* -----------------------------------------------------------------------------
* (c) Copyright 2018 SAKAIDEN and CaptainHansode. All rights reserved.
* @License MIT
* @Auther 半袖船長
* @Web http://www.sakaiden.com/
* @Email sakaiden@live.jp
* @github https://github.com/CaptainHansode/SJTools
*
*/


function JSON4Jsx()
{
    this.name = "JSON4Jsx";

    /**---------------------------------------------------------------
     * add "
     * @param {string} str
     * @return {string} -out_str
     */
    this.addQmark = function(in_str)
    {
        out_str = ["\"", in_str, "\""];
        return out_str.join("");
    }

    /**-------------------------------------------------------------------------
     * string Multiply
     * @return {string} -string
     */
    this.strMlt = function(str, dig)
    {
        var str = str || "";
        var dig = dig || 1;

        var ret = "";
        for (var i = 0; i < dig; i++) {
            ret += str;
        }
        return ret;
    }

    /**---------------------------------------------------------------
     * convert data to strings
     * @param {string} str
     * @return {string} json string
     */
    this.arrayToString = function(arr) {
        var arr = arr || [];
        if (arr.length == 0) {
            return "[]";
        }

        var result = ["["];
        for (var i=0; i<arr.length; i++) {
            var val = arr[i];
            var val_type = val.constructor;
            if (val_type == String) {
                val = val.replace(/\\/g, "\\\\");
                result.push(this.addQmark(val));
            } else if (val_type == Array) {
                result.push(this.arrayToString(val));
            } else if (val_type == Object) {
                result.push(this.stringify(val));
            } else {
                result.push(val);
            }
            result.push(", ");
        }
        result.pop();
        result.push("]");
        return result.join("");
    }

    /**---------------------------------------------------------------
     * convert data to strings
     * @param {string} str
     * @return {string} json string
     * TODO:インデント未対応 たぶん要らない
     */
    this.stringify = function(j_data, indent)
    {
        var j_data = j_data || {};
        var indent = indent || 0;
        if (j_data.constructor != Object) {
            return null;
        }

        var result = ["{"];
        result.push(" ");
        for(var key in j_data) {
            result.push(this.addQmark(key));
            result.push(": ");
            var val = j_data[key];
            var val_type = val.constructor;
            if (val_type == String) {
                val = val.replace(/\\/g, "\\\\");
                result.push(this.addQmark(val));
            } else if (val_type == Array) {
                result.push(this.arrayToString(val));
            } else if (val_type == Object) {
                result.push(this.stringify(val, indent));
            } else {
                result.push(j_data[key]);
            }
            result.push(", ");
        }
        result.pop();
        result.push("}");
        return result.join("");
    }

    /**---------------------------------------------------------------
     * convert data to dictionary
     * @param {string} j_data
     * @return {dictionary} dict
     */
    this.parse = function(j_data)
    {
        j_data = j_data || "{}";
        e_str = ["result", j_data];
        eval(e_str.join("="));  // evalで評価
        return result;
    }
}