# indexing with `namedtuple`


### A basic class for an easily subsetable dictionary using Python's [`namedtuple`](http://docs.python.org/2/library/collections.html#namedtuple-factory-function-for-tuples-with-named-fields) as keys for multidimensional indexing (01.04.14)


Dictionaries/HashMaps/[HashTables](http://en.wikipedia.org/wiki/Hash_table) are great. Having items stored and returned at constant time complexity makes building up data structures, and finding items within them, a breeze.

But what if my item has multiple features? What if I want to get all the items that have a certain values for some of those features? Ideally, I could index a dictionary with a few different attributes (in the form of another dictionary) and get back the item (if a full key is passed), or a set of items if a partial key is passed. An example usage of what I want might look like this...

```language-python
>>> T = {}
>>> T[{"a":1,"b":True, "c":"string"}] = 4
>>> T[{"a":2,"b":True, "c":"string"}] = 5
>>> T[{"a":3,"b":False,"c":"string"}] = 6
>>> T[{"b":True}]
{{'{{"a":1, "c":"string"}: 4, {"a":2, "c":"string"}: 5}'}}
>>> T[{"a":3,"b":False,"c":"string"}]
6
```

If the above code is executed, the interpreter will inform you that dictionaries are unhashable, as they are [mutable](http://docs.python.org/2/reference/datamodel.html), and thus cannot be used as keys. However, if the set of attributes are known beforehand, this can be fixed with a special Python data structure. Bringforth the elegance of the [namedtuple](http://docs.python.org/2/library/collections.html#namedtuple-factory-function-for-tuples-with-named-fields). Namedtuples are a sort of mini-class, with a succinctly defined constructor, as shown in this completely valid example:

```language-python
from collections import namedtuple

# Peanut constructor, defined by namedtuple invocation
p = namedtuple("Peanut",["shell","salted"])

salty = p(shell="closed",salted=True)
print(salty.shell)

not_salty = p(shell="closed",salted=False)
eaten = p(shell="open",salted=False)

# 20 salty peanuts and 50 unsalted
Bowl_Contents = {salty:20, not_salty:50}

# Get back the number of salty peanuts
print(Bowl_Contents[p(shell="closed",salted=True)])
```

Above we have defined a reference `p` to a peanut namedtuple constructor. It can subsequently be called to invoke new peanuts, with different shell and saltiness specifications. Furthermore, the fact that namedtuples are tuples, and therefore [immutable](http://stackoverflow.com/questions/8056130/immutable-vs-mutable-types-python), means they can serve as dictionary keys.

Below, I offer a basic class which utilizes named tuples to allow for indexing with dictionaries. Additionally, just as was desired in the first theoretical code example, subsets of full keys can also be used as indexes, returning all applicable items. This is a very limited (purely for fun) implementation, as normal dictionary methods like `keys()` aren't present - however they can easily be added though by wrapping calls to `self.storage`'s methods in new method definitions.

```language-python
from pprint import pformat
from collections import namedtuple

class MetaDict(object):
  ''' Sliceable, subsetable dictionary '''
  
  def __init__(self, key_components):
    self.storage = {}
    self.key = namedtuple("multiKey",key_components)

  def __repr__(self):
    ''' pretty print representation '''
    return "{}:\n{}\n".format(
      str(self.__class__)[17:-2], 
      pformat(self.storage)
    )

  def __setitem__(self, index, item):
    ''' Set an item using a dictionary as an index '''
    # Hey! Some of those keys fields aren't right!
    k = index.keys()
    fields = self.key.fields
    if not set(k) <= set(fields):
      invalid = set(k) - set(fields)
      raise Exception("Incorrect Key: {}".format(invalid))
    else:
      self.storage[self.key(**index)] = item
    
  def __getitem__(self, query):
    ''' If the query is a full key, return the item. 
        Otherwise, return a smaller MetaDict object 
        containing all items which have key elements 
        matching those specified in the query '''   

    # If the query is a full key, return the value
    keys = query.keys()
    fields = self.key.fields
    if set(keys) == set(fields):
      return self.storage[self.key(**query)]

    # Hey! Some of those keys fields aren't right!
    if not set(keys) <= set(fields):
      invalid = set(keys) - set(fields)
      raise Exception("Invalid Key: {}".format(invalid))

    # The new key for the smaller MetaDict 
    # will have the elements
    # not listed in the query.
    newfields = [k for k in fields if k not in keys]

    if len(newfields) > 1:
      results = MetaDict(newfields)
      mutiple_field_key = True            
    else:
      # Defaults to normal dictionary
      results = {}
      mutiple_field_key = False

    # Loop through all current entries
    for key in self.storage:
      
      if all(getattr(key,k) == v for (k,v) in query.items()):
        
        # create a dictionary of items NOT included in the query
        # to be used as the new sub key
        sub_key = {
          k:v for (k,v) in key._asdict().items() 
          if k not in keys
        }      

        if mutiple_field_key:
          # Store the value in the new MetaDict
          results[sub_key] = self.storage[key]
        else:
          # No longer need multidimensional indexing
          results[list(sub_key.values())[0]] = self.storage[key]
      
    return results
```

Finally, here is an example usage of the above class (thrown into a file `metadict.py`), with the exact indexing and sub-setting we were hoping for! 

```
>>> from metadict import MetaDict
>>> T = MetaDict(["a","b","c"])
>>> T[{"a":1,"b":True, "c":"string"}] = 4
>>> T[{"a":2,"b":True, "c":"string"}] = 5
>>> T[{"a":3,"b":False,"c":"string"}] = 6
>>> T[{"a":2}]
MetaDict:
{multiKey(b=True, c='string'): 5}

>>> T[{"b":True}]
MetaDict:
{multiKey(a=1, c='string'): 4, multiKey(a=2, c='string'): 5}

>>> T[{"a":3,"b":False,"c":"string"}]
6
```