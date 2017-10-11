import Foundation
/**
 * To 
 */
class MDUtils{
    static var pattern = "( *?)\\- \\[( |X)\\] ([\\w\\n\\-\\[\\] ]*?)(?=\\n(\\1)\\-|$)"//pattern for extracting the tree-structure
    static var titlePattern:String = "^[\\w]*?(?=\\n)"//pattern for extracting
    static var depth = 0
    /**
     * Returns a Array/Dictionary tree structure
     */
    class func items(str:String)->[Dictionary<String,Any>]{
        var theItems = [Dictionary<String,Any>]()
        let matches = RegExp.matches(str, pattern)
        for match:NSTextCheckingResult in matches {
            match.numberOfRanges
            var item:Dictionary<String,Any> = [:]
            let bool = (str as NSString).substringWithRange(match.rangeAtIndex(2))
            item["bool"] = bool
            let content = (str as NSString).substringWithRange(match.rangeAtIndex(3))
            //print(content)
            if(content.characters.contains(Character("\n"))){//asserts if the node has children
                //print("has children")
                let titleMatch = RegExp.match(content,titlePattern)//extracts the title
                //print(theMatch)
                item["title"] = titleMatch[0]
                item["children"] = items(content)
            }else{
                item["title"] = content
            }
            theItems.append(item)
        }
        return theItems
    }
    
    /**
     * Returns PARAM: str n-times
     */
    class func multiplyString(var str:String, _ multiplier:Int)->String{
        if(multiplier == 0){
            return ""
        }
        for var i = 1; i < multiplier; ++i{
            str += str
        }
        return str
    }
    /*
    * Prints the "tree structure" as markdown syntax
    */
    class func traverseTree(items:[Dictionary<String,Any>])->String{
        Swift.print("traverseTree: ")
        var returnTxt:String = ""
        for item in items {
            //print(item["title"]!)
            
            let txt:String = multiplyString("  ", depth) + "- [" + (item["bool"] as! String) + "]" + " " + (item["title"] as! String) + "\n"
            
            //print(txt)
            returnTxt += txt
            if let children = (item["children"] as? [Dictionary<String,Any>]){
                depth++ //increase depth
                returnTxt += traverseTree(children)
                depth-- //decrease depth
            }
        }//depth is zero again when the loop is complete
        return returnTxt
    }
    /*
    * Sorts trees
    * Note: this method is recursive
    * NOTE: You may use inout with the items arg here.
    */
    class func sort(items:[Dictionary<String,Any>], _ reverse:Bool = false)->[Dictionary<String,Any>]{
        Swift.print("sort")
        var complete:[Dictionary<String,Any>] = []
        var inComplete:[Dictionary<String,Any>] = []
        for var item:[String:Any] in items{
            if let children = (item["children"] as? [Dictionary<String, Any>])  {
                item["children"] = sort(children,reverse)//Sort the subTasks (recursively!!!)
            }
            ((item["bool"]! as! String) == "X") != reverse ? complete.append(item) : inComplete.append(item)
        }
        let returnArr = complete + inComplete
        return returnArr
    }
}