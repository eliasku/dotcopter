package utils
{

// ArraysUtil AS3 functions
// author: http://flanture.blogspot.com 
// license: Creative Commons Attribution-Share Alike 3.0 
// http://creativecommons.org/licenses/by-sa/3.0/
// contact: flanture@gmail.com
// March 2010

    import flash.display.Sprite;

    public class ArraysUtil extends Sprite 
    {
        
        public function ArraysUtil() 
        {
            
            // example usage
            
            var a:Array = [1,2,3,5,3];
            var b:Array = [2,4,6,8];
            var c:Array = [1,2,3,5,3];
            var d:Array = [5,7,9,5,5,7,5,7,9];
            var e:Array = [5,5,9];
            var f:Array = [5,7,9,5,5,7,5,7,9];
            trace("array a: "+a);
            trace("array b: "+b);
            trace("array c: "+c);
            trace("array d: "+d);
            trace("array e: "+e);
            trace("array f: "+f);
            trace("* * * * *");
            trace("is there element 6 inside array b?");
            search(6, b);
            trace("a combined with b: "+combine(a,b));
            trace("6 exists in b? "+searchB(6,b));
            trace("number of 3 in a? "+searchCount(3,a));
            trace("intersection of a and b: "+iSection(a,b));
            trace("shuffled b: "+shuffle(b));
            trace("exclude element 3 from array c : "+exclude(3,c));
            trace("exclude all array e elements from array d :"+excludeAll(e, d));
            trace("unique of f :"+unique(f));
        }

        // function search finds element in array and displays result        
            
        public static function search(word:Object, arr:Array):void 
        {
                var exists:Boolean = false;
                for(var i:uint=0; i < arr.length; i++)
                {
                    if(arr[i]==word)
                    {
                        trace("Element exist on position "+i);
                        exists = true;
                    }
                }
                if(!(exists))
                {
                    trace("Element doesn't exist in array.");
                }
        }
            
        // function searchB finds element in array and returns Boolean value
            
        public static function searchB(word:Object, arr:Array):Boolean 
        {
                var exists:Boolean = false;
                for(var i:uint=0; i < arr.length; i++) 
                {
                    if(arr[i]==word)
                    {
                        exists = true;
                    }
                }
                return exists;
        }
            
        // function searchCount returns number of apperances of element in array
            
        public static function searchCount(word:Object, arr:Array):uint 
        {
                var counter:uint = 0;
                for(var i:uint=0; i < arr.length; i++) 
                {
                    if(arr[i]==word){
                        counter+=1;
                    }
                }
                return counter;
        }
            
        // function iSection returns intersection array of two arrays
            
        public static function iSection(arr1:Array, arr2:Array):Array 
        {
                var arr3:Array = new Array();
                var count:uint = 0;
                for(var i:uint=0; i < arr1.length; i++)
                {
                    for(var j:uint=0; j < arr2.length; j++)
                    {
                        if(arr1[i]==arr2[j])
                        {
                            arr3[count] = arr1[i];
                            count+=1;
                        }
                    }
                }
                return arr3;
        }
            
        // function shuffle simply shuffles given array elements
            
        public static function shuffle(b:Array):Array 
        {
                var temp:Array = new Array();
                var templen:uint;
                var take:uint;
                while (b.length > 0) 
                {
                    take = Math.floor(Math.random()*b.length);
                    templen = temp.push(b[take]);
                    b.splice(take,1);
                }
                return temp;
        }
            
        // function combine returns union of two arrays
        
        public static function combine(ar1:Array, ar2:Array):Array 
        {
            var rAr:Array = new Array();
            var i:uint = 0;
            var j:uint = 0;
            
            while((i < ar1.length) || (j < ar2.length)) 
            {
                if(i < ar1.length)
                {
                    rAr.push(ar1[i]);
                    i+=1;
                }
                if(j < ar2.length)
                {
                    rAr.push(ar2[j]);
                    j+=1;
                }
            }
            return rAr;        
        }
        
        // function exclude remove all appearances of element inside given array
        
        public static function exclude(elem:Object, arr:Array):Array
        {
            var temp:Array = new Array();
            
            for(var i:uint = 0; i < arr.length; i++)
            {
                if(!(arr[i]==elem))
                {
                    temp.push(arr[i]);
                }
            }
            return temp;
        }
    
        // function excludeAll remove all appearances of ar1 elements inside ar2 array
        
        public static function excludeAll(ar1:Array, ar2:Array):Array
        {
            var temp:Array = new Array();
            ar1 = unique(ar1);

            while(ar2.length > 0)
            {
                if(searchCount(ar2[0], ar1) == 0)
                {
                    temp.push(ar2[0]);
                }
                ar2.splice(0, 1);
            }
            return temp;
        }
        
        public static function unique(arr:Array):Array
        {
            var res:Array = new Array();

            while(arr.length > 0)
            {
                if(searchCount(arr[0], arr) == 1)
                {
                    res.push(arr[0]);
                }
                arr.splice(0,1);
            }
            return res;
        }
    }
}