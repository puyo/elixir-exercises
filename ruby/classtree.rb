#!/usr/bin/ruby -w

def class_tree(root, show_methods = true, colorize = true)

  # get children of root
  children = Hash.new()
  maxlength = root.to_s.length
  ObjectSpace.each_object(Class) do |aClass|
    if (root != aClass && aClass.ancestors.include?(root))
      children[aClass.superclass] = Array.new() if children[aClass.superclass] == nil
      children[aClass.superclass].push(aClass)
      maxlength = aClass.to_s.length if aClass.to_s.length > maxlength
    end
  end
  maxlength += 3

  # print nice ascii class inheritance tree
  indentation = " "*4
  c = Hash.new("")
  if colorize
    c[:lines]       = "\033[34;1m"
    c[:dots]        = "\033[31;1m"
    c[:classNames]  = "\033[33;1m"
    c[:moduleNames] = "\033[32;1m"
    c[:methodNames] = "\033[39;m"
  end
  
  recursePrint = proc do |current_root,prefixString|
    if show_methods # show methods (but don't show mixed in modules)
      puts(prefixString.tr('`','|'))
      methods = (current_root.instance_methods(false) - (begin current_root.superclass.instance_methods(true); rescue NameError; []; end))
      strings = methods.sort.collect {|m|
        prefixString.tr('`',' ') +
        ( children[current_root] == nil ? " "*maxlength : c[:lines]+indentation+"|"+" "*(maxlength-indentation.length-1)) +   
        c[:dots]+":.. " +
        c[:methodNames]+m.to_s
      }
      strings[0] = prefixString + c[:lines]+"- "+c[:classNames]+current_root.to_s
      strings[0] += " " + c[:dots]+"."*(maxlength-current_root.to_s.length) + " "+c[:methodNames]+methods[0] if methods[0] != nil
      strings.each {|aString| puts(aString) }
    else
      string = prefixString + c[:lines]+"- " +c[:classNames]+current_root.to_s
      modules = current_root.included_modules - [Kernel]
      if modules.size > 0
        string += " "*(maxlength-current_root.to_s.length)+c[:lines]+"[ "+c[:moduleNames]+
          modules.join( c[:lines]+", "+c[:moduleNames]) +
          c[:lines]+" ]"
      end
      puts(string)
    end
    if children[current_root] != nil
      children[current_root].sort! {|a, b| a.to_s <=> b.to_s}
      children[current_root].each do |child|
          recursePrint.call(
            child,
            prefixString.tr('`',' ') + indentation + c[:lines]+(child == children[current_root].last ? "`":"|"))
      end
    end
  end

  recursePrint.call(root,"")
end
