#"R For Data Science" eBook Tutorial Notes & Code : ) , Book:https://r4ds.had.co.nz/index.html
#03/05/2020 MMS

#PRESS ALT/SHIFT/K TO SEE R KEYBOARD SHORTCUTS*** 

#Load package:
  library(tidyverse)
  library(ggplot2)

##Data Visualization Using ggplot2 package
  
#Learn about the R data set I'll be using
  ?mpg

#Look at the structure of this dataset
  str(mpg)

#View the data frame 
  View(mpg)

#When viewing the dataframe notice what the variables are (displ is a car's engine size in litres, 
# hwy is a car's fuel efficiency on the highway in miles per gallon)

#Create a ggplot (plotting mpg where displ is on the x-axis, and hwy is on the y-axis)
  ggplot(data = mpg) +
    geom_point(mapping = aes(x = displ, y = hwy))

#The geom function in ggplot2 takes a mapping argument that defines how variables in your dataset
# are positioned

#Graphing template for any dataset- "<CAPS>" items to be replaced each time:
#ggplot(data = <DATA>) +
#<GEOM_FUNCTION>(mapping = aes( <MAPPINGS>))

#Plot Aesthetics 
#Group the dots on a scatter plot by a variable called  class (this example is the type of car it is)
  ggplot(data = mpg) +
      geom_point(mapping = aes(x = displ, y= hwy, color = class))
  
#Instead of mapping class with color, we can do so with size of dot shows greater or less 
# environmental impact
  ggplot(data = mpg) +
      geom_point(mapping = aes(x = displ, y = hwy, size = class))

#Or we could have mapped  class  to the alpha aesthetic, which controls the transparency of the
#points, or to the shape aesthetic, which controls the shape of the points.
  
  ggplot(data = mpg) + 
    geom_point(mapping = aes(x = displ, y = hwy, alpha = class))
  

  ggplot(data = mpg) + 
    geom_point(mapping = aes(x = displ, y = hwy, shape = class))
  
#Setting your own aesthetic properties (like chooing what colors you want for what)
  ggplot(data= mpg) +
    (geom_point(mapping = aes(x = displ, y = hwy), color = "blue"))
  
#Color and shape options:  
#R has 25 built in shapes that are identified by numbers. There are some seeming duplicates: 
#for example, 0, 15, and 22 are all squares. The difference comes from the interaction of the
#colour  and  fill  aesthetics. The hollow shapes (0-14) have a border determined by  colour ; 
#the solid shapes (15-18) are filled with  colour ; the filled shapes (21-24) have a border of 
#colour  and are filled with  fill . 
  
#Adding Facets (subplots of your data for side by side comparisons)
  ggplot(data = mpg) +
    geom_point(mapping = aes(x = displ, y= hwy)) +
    facet_wrap( ~ class, nrow = 2)
  
# Notes: A geom is the geometrical object that a plot uses to represent data. People often
#describe plots by the type of geom that the plot uses. For example, bar charts use bar geoms,
#line charts use line geoms, boxplots use boxplot geoms, and so on. Scatterplots break the trend;
#they use the point geom. As we see above, you can use different geoms to plot the same data.

#Examples of the same data being plotted using different geoms:
  ggplot(data = mpg) +
      geom_point(mapping = aes(x = displ, y= hwy))
  
  ggplot(data = mpg) +
      geom_smooth(mapping = aes(x = displ, y = hwy))
  
# Different line types (dashed and dotted)
  ggplot(data = mpg) +
      geom_smooth(mapping = aes(x= displ, y= hwy, linetype = drv))
  
# Add multiple geoms to the same plot
# Add a line and dots to display the data together:
  ggplot(data = mpg) +
    geom_point(mapping = aes(x = displ, y = hwy)) +
    geom_smooth(mapping = aes(x = displ, y = hwy))
  
#code shortcuts: since this code ^ is duplicated, if you needed to change the axis to another variable you'd 
#need to in more than one place,risking an error to pop up if you forgot to change one, instead pass a set of mappings- 
      ggplot(data = mpg, mapping = aes(x = displ, y= hwy)) +
        geom_point() +
        geom_smooth() 

#If you place mappings in a geom function, ggplot2 will treat them as local mappings for the layer.
#It will use these mappings to extend or overwrite the global mappings for that layer only. This makes 
#it possible to display different aesthetics in different layers.
      ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
          geom_point(mapping = aes(color = class)) +
          geom_smooth ()

#You can use the same idea to specify different  data  for each layer. Here, our smooth line
#displays just a subset of the  mpg  dataset, the subcompact cars. The local data argument 
#in  geom_smooth()  overrides the global data argument in  ggplot()  for that layer only.
      ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
        geom_point(mapping = aes(color = class)) +
        geom_smooth(data = filter(mpg, class == "subcompact"), se = FALSE)

#Statistical transformations 
#Working with another dataset: "diamonds"
      View(diamonds)
      str(diamonds)

#Make a bar chart showing teh distribution of diamond quality 
      ggplot(data = diamonds) +
        geom_bar(mapping = aes(x = cut))
      
#The x-axis ^ is the variable "cut" from the diamond dataframe, and the y-axis is count which
#was automatically generated by R. 
#The algorithm used to calculate new values for a graph is called a stat, short for statistical transformation.      
      
#Instead of the geom_bar() function, you can also use stat_count() interchangably.
      ggplot(data = diamonds) +
          stat_count(mapping = aes(x = cut))
#There are 3 instances where it is better to use the stat function specifically"- 
      
      #1. If you wnat to override the default stat: in the code below the stat of geom_bar is changed from count to 
          # identity allowing you to map the height of the bars to the raw values of a y variable. 
        demo <- tribble(
          ~cut, ~freq,
          "Fair", 1610,
            "Good", 4906,
          "Very good", 12082,
          "Premium", 13791,
          "Ideal", 21551,
          )
        
        ggplot(data = demo) +
          geom_bar(mapping = aes(x = cut, y = freq), stat = "Identity")
    
      #2. to override the default mapping from transformed variables to aesthetics. For example,
          #you might want to display a bar chart of proportion, rather than count: 
        ggplot(data = diamonds) +
          geom_bar(mapping = aes(x = cut, y = stat(prop), group = 1))
      
      #3.to draw greater attention to the statistical transformation in your code. For example, 
         #you might use  stat_summary() , which summarises the y values for each unique x value, 
         #to draw attention to the summary that you're computing:
        ggplot(data = diamonds) +
          stat_summary(
            mapping = aes(x = cut, y = depth),
            fun.ymin = min,
            fun.ymax = max,
            fun.y = median,
          )
#Position Adjustments
#creating colored bar charts (outlined or filled in):
        ggplot(data = diamonds) +
          geom_bar(mapping = aes(x = cut, colour = cut))
        
        ggplot(data = diamonds) +
          geom_bar(mapping = aes(x = cut, fill = cut))

#Note what happens if you map the fill aesthetic to another variable, like  clarity : 
#the bars are automatically stacked. Each colored rectangle represents a combination of
#cut  and  clarity. 
        ggplot(data = diamonds) +
          geom_bar(mapping = aes(x = cut, fill = clarity))

#The stacking ^ is performed automatically by the position adjustment specified by the  position  argument. 
#If you don't want a stacked bar chart, you can use one of three other options:  "identity"(places an object exactly
#where it falls in context w the graph) ,"dodge"(side by side rather than stacked), or 
#"fill" (works like stacking, but each of the bars are the same height).
  
#Coordinate Systems
#The default coordinate system is the Cartesian coordinate system where the x and y positions act independently to determine 
#the location of each point. There are a number of other coordinate systems that are occasionally helpful.
#coord_flip()  switches the x and y axes. This is useful (for example), if you want horizontal boxplots. It's also useful for 
#long labels: it's hard to get them to fit without overlapping on the x-axis.
        ggplot(data =mpg, mapping = aes(x = class, y = hwy)) +
          geom_boxplot()
        
        ggplot(data = mpg, mapping =aes(x = class, y = hwy)) +
          geom_boxplot() +
            coord_flip()
#If plotting spacial data, like maps:
        nz <- map_data("nz")
        
        ggplot(nz, aes(long,lat, group = group)) +
          geom_polygon(fill = "white", colour = "black" ) +
          coord_quickmap()
# coord_polar()uses polar coordinates. Polar coordinates reveal an interesting connection between a bar chart and
#a Coxcomb chart. 
          bar <- ggplot(data = diamonds) +
            geom_bar(
              mapping = aes(x = cut, fill = cut),
              show.legend = FALSE,
              width = 1
            ) +
            theme(aspect.ratio = 1) +
            labs(x = NULL, y = NULL)
          
          bar + coord_flip()
          bar + cood_polar()
#"The layered grammar of graphics"
# Cumulative code template:
#          ggplot(data = <DATA>) +
#            <GEOM_FUNCTION>(
#              mapping = aes(<MAPPINGS>), 
#              stat =<STAT>, 
#              position = <POSITION>
#            ) +
#            <COORDINATE_FUNCTION> + 
#            <FACET_FUNCTION>
          

          
          
##Data Transformation 
          
#download packages
          
          library(tidyverse)
          install.packages("nycflights13")
          library(nycflights13)

# Take careful note of the conflicts message that's printed when you load the tidyverse.
# It tells you that dplyr overwrites some functions in base R. If you want to use the base
# version of these functions after loading dplyr, you'll need to use their full names: 
# stats::filter()  and  stats::lag()   
          
# learn about the data set i am working on:
          ?flights
          str(flights)
          View(flights)
  
          
# int stands for intergers, dbl stands for doubles or real numbers, chr stands for character strings or vectors, 
#dttm stands for date-times, lgl stands for logical vectors that are binary TRUE/FALSE, fctr stadnds for factors
          
#dyplr basics:
# .Pick observations by their values ( filter() ).
# .Reorder the rows ( arrange() ).
# .Pick variables by their names ( select() ).
# .Create new variables with functions of existing variables ( mutate() ).
# .Collapse many values down to a single summary ( summarise() ).
          
#Filter rows with filter() (selecting all of the flights that happened on January 1st)
          filter(flights,  month == 1, day == 1)
   #save this filtered dataset:
          jan1 <- filter(flights, month == 1, day == 1)
          
# R either prints the results or saves it to a variable or object, to do both at the same time wrap it in 2nd 
# parenthesis at the end.
       (dec25 <- filter(flights, month == 12, day == 25))   
          
#Arrange rows with the arrange() function and desc() to re-order by column in descending order
          arrange(flights, year, month, day)
          
          arrange(flights, desc(dep_delay))

#Comparisons- you can use near() to get an approximation instead of == as computers will only give an 
#approximation anyways (they wont store an infinate number of digits)
          near(sqrt(2) ^ 2 == 2)
            
# Boolean operators include and "&", or "|", not "!" in R. *Equal to is ==, not = in R. != is not equal. 

          
#Add new variables with the mutate() function
#Besides selecting sets of existing columns, it's often useful to add new columns that are functions of existing
#columns. That's the job of  mutate(). mutate()  always adds new columns at the end of your dataset. 
          
        flights_sml <- select(flights, 
              year::day,
              ends_with("delay"),
              distance,
              air_time
              )
              mutate(flights_sml,
              gain = dep_delay - arr_delay,
              speed = distance/air_time * 60
              )

#If you only want to keep the new variables, then use transmutate() 
              
              
              
              
  
          


          
            
    
