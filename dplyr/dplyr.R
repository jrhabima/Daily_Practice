library(dplyr)
#select() 
#filter()
#mutate() 
#group_by() 
#summarise()
#arrange() 
#join()
set.seed(404)
data <- data.frame(x = rnorm(100, 10,1), y = runif(100, 1, 10), 
                   names = c(rep("a",10), rep("b",80), rep("c", 10)), 
                   salary = c(rep(3000,40), rep(4000, 30), rep(5000, 30))
                   
)

data
# Remove duplicate rows and check number of rows

data %>% distinct() %>% nrow() # found that all the rows are different

# Drop duplicate rows and assign to new dataframe object
data_clean <- data %>% distinct()

# Drop duplicates based on one or more variables
data%>% distinct(names, .keep_all = T)
data %>% distinct(names, salary, .keep_all =  T) # names and salary are different

# Taking random samples of data is easy with dplyr.

# Sample random rows with or without replacement
sample_n(data, size = nrow(data) * 0.7, replace = F) # without replacement/distinct samples
sample_n(data, size = 20, replace = T) # with replscement/may have same samples

# Sample a proportion of rows with or without replacement
sample_frac(data, size = 0.7, replace = F)
sample_frac(data, size = 0.8, replace = T)

# Renaming variables is also easy with dplyr.

# Rename one or more variables in a dataframe
#data <- data %>%
 # rename("NAMES" = "names", "SALARY" = "salary") # new name first


# select() verb which filters a dataframe by column.

data%>%
select(c("NAMES", "x")) # select specific columns

# With dplyr 0.7.0 the pull() function extracts a variable as a vector

data %>%
pull(y)

#Drop a column using the - operator (referenced by name or column position)

data %>%
  select(-NAMES)

data %>%
 select(-1, -4)

#filter() which, surprisingly enough, filters a dataframe by row based on one or more conditions.

# Filter rows to retain observations where x is greater than 30

f<- data %>%
filter(x > 10)
dat<- data %>%
 subset(x >10)
all.equal(dim(f), dim(dat)) # filter and subset are doing the same thing

# Filter by multiple conditions using the %in% operator (make sure strings match)

data%>%
  filter(salary %in% c("3000", "5000"))

data%>%
  subset(salary == c("3000", "4000")) # subset does it easier

# You can also use the OR operator (|)
data%>%
  filter(salary == "3000"| salary == "5000")

# Filter using the AND operator
data %>%
  filter(x > 11 & salary == "4000")

# You can also use subset()

data%>%
  subset(x > 11 & salary == "4000")

# Combine them too

data %>%
  filter(salary %in% c("5000", "4000") & y >= 9)

# The summarise() verb in dplyr is useful for summarising grouped data

data %>%
  filter(x >= " 10") %>%
  summarise(mean_x= mean(x),
            median_x = median(x),
            sd_x = sd(x))

#arrange()verb which is useful for sorting data in ascending or descending order (ascending is default).
# Sort by ascending age and print top 10
data %>%
  arrange(x) %>%
  head(10)

# Sort by descending age and print top 10
data%>%
  arrange(desc(x)) %>%
  head(10)

#group_by() verb is useful for grouping together observations which share common characteristics.

# The group_by verb is extremely useful for data analysis

data %>% 
  group_by(names)%>%
  summarise(Mean = mean(salary))

data %>%
group_by(names) %>%
  summarise(total = n())

data %>%
  group_by(names) %>%
  summarise(total = n(),
            mean_salary = mean(salary))

#The mutate() verb is used to create new variables from existing local variables or global objects.
#New variables, such as sequences, can be also specified within mutate().

# Create new variables from existing or global variables

data %>% 
  mutate(standardised_salary = (salary - mean(salary)) / sd(salary))

#The join() verb is used to merge rows from disjoint tables which share a primary key ID  or some other common variable. 
#There are many join variants but I will consider just left, right, inner and full joins.

# Create ID variable which will be used as the primary key

data <- data %>%
  mutate(ID = seq(1:nrow(data))) %>%
  select(ID, everything()) ## everything means it comes before other variables

# Create two tables (purposely overlap to facilitate joins)

table_1 <- data[1:50 , ] %>%
  select(ID, names, x)

table_2 <- data[26:75 , ] %>%
  select(ID, y, salary)  # the two tables have some rows in common. data[26:50, ]

# Left join joins rows from table 2 to table 1 (the direction is implicit in the argument order)

left_join(table_1, table_2, by = "ID")


# Right join joins rows from table 1 to table 2
right_join(table_1, table_2, by = "ID")

# Inner join joins and retains only complete cases
inner_join(table_1, table_2, by = "ID")

# Full join joins and retains all values
full_join(table_1, table_2, by = "ID")

# subset()
subset(data, names == "a" & x < 10) # selct induviduals with given characterictics.
head(data)

