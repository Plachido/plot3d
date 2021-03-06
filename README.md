# plot3d

Having the three axes data a three dimensional animated plot gets generated. Points can have different colours based on which cluster they are in, and different shape if they are misclassified instances. The whole plot is generated with the `rgl` library, while the (optional) animation is made with the library `magick`.

## USAGE
```
x = x axis,
y = y axis,
z = z axis,
groups = found clusters,
truth = actual clusters,
axis_n = vector of labels
spin = animation option

plot_3d(x,y,z, groups, truth, axis_n, spin = TRUE)
```
In the following example the result of mclust model based clustering gets plotted, and misclassificated instances are shown as squares (made on Wine dataset).
  
![](ex.gif)

<b>NOTE:</b> no axis labels have been insered on this example.
