library(rgl)
library(magick)

plot_3d<-function(x,y,z,groups=1,truth=groups, axis_n=c("x","y","z")){
  rgl_init <- function(new.device = FALSE, bg = "white", width = 640) {
    if( new.device | rgl.cur() == 0 ) {
      rgl.open()
      par3d(windowRect = 50 + c( 0, 0, width, width ) )
      rgl.bg(color = bg )
    }
    rgl.clear(type = c("shapes", "bboxdeco"))
    rgl.viewpoint(theta = 15, phi = 20, zoom = 0.7)
  }
  rgl_add_axes <- function(x, y, z, axis.col = "grey",
                           xlab = axis_n[1], ylab=axis_n[2], zlab=axis_n[3], show.plane = TRUE,
                           show.bbox = TRUE, bbox.col = c("#333377","black"))
  {
    lim <- function(x){c(-max(abs(x)), max(abs(x))) * 1.1}
    # Add axes
    xlim <- lim(x); ylim <- lim(y); zlim <- lim(z)
    rgl.lines(xlim, c(0, 0), c(0, 0), color = axis.col)
    rgl.lines(c(0, 0), ylim, c(0, 0), color = axis.col)
    rgl.lines(c(0, 0), c(0, 0), zlim, color = axis.col)

    # Add a point at the end of each axes to specify the direction
    axes <- rbind(c(xlim[2], 0, 0), c(0, ylim[2], 0),
                  c(0, 0, zlim[2]))
    rgl.points(axes, color = axis.col, size = 3)

    # Add axis labels
    rgl.texts(axes, text = c(xlab, ylab, zlab), color = "purple",
              adj = c(0.5, -0.8), size = 2)

    # Add bounding box decoration
    if(show.bbox){
      rgl.bbox(color=c(bbox.col[1],bbox.col[2]), alpha = 0.5,
               emission=bbox.col[1], specular=bbox.col[1], shininess=5,
               xlen = 3, ylen = 3, zlen = 3)
    }
  }
  levs=levels(as.factor(groups))
  rgl_init()
  ellipse_col <- c("red", "green", "blue","brown","yellow")

  if(truth!=groups){
    pch3d(x, y, z, pch = ifelse(groups==data[,1],20,15),
          bg = material3d("color")[1], cex = 1, color = groups, lit = FALSE)
  }
  else{
    rgl.spheres(x, y, z, r = 0.1, color = groups)
  }
  rgl_add_axes(x, y, z, show.bbox = TRUE)
  for (i in 1:length(levs)) {
    group <- levs[i]
    selected <- groups == group
    xx <- x[selected]; yy <- y[selected]; zz <- z[selected]
    ellips <- ellipse3d(cov(cbind(xx,yy,zz)),
                        centre=c(mean(xx), mean(yy), mean(zz)), level = 0.95)
    shade3d(ellips, col = ellipse_col[i], alpha = 0.1, lit = FALSE)
    # show group labels
    texts3d(mean(xx),mean(yy), mean(zz), text = group,
            col= ellipse_col[i], cex = 1)
  }
  aspect3d(1,1,1)
  movie3d(spin3d(axis = c(0, 1, 0)), duration = 10,
          dir = getwd())
}
