plot_ROH_IID <-
  function (ROH,
            unit,
            regions,
            color2 = "green4",
            main = "", 
            build) {
    if (unit == "cM") {
      ecart <- 25
      larg  <- 2
      pos1  <- which(colnames(ROH) == "POS1_cM")
      
      pos2  <- which(colnames(ROH) == "POS2_cM")
      
      if (length(pos1) == 0)
        stop("no genetic distances in ROH file")
    }
    
    else if (unit == "bases") {
      ecart <- 25e6
      larg  <- 2
      pos1  <- which(colnames(ROH) == "POS1")
      pos2  <- which(colnames(ROH) == "POS2")
    }
    else
      stop("length option accepts cM and bases only")
    
    #plot vide
    plot(
      x = c(larg * 0.5, larg * 11.5),
      y = c(
        0,
        lengthChromosome(1, unit, build=build)  +
          lengthChromosome(12, unit) + 1.25 * ecart, build=build),
      type = "n",
      xaxt = "n",
      yaxt = "n",
      xlab = "",
      ylab = "",
      main = main,
      cex.main = 1.5
    )
    
    #11 premiers chromosomes
    for (i in 1:11) {
      paintCytobands(
        i,
        units = unit,
        pos = c(
          larg * i,
          lengthChromosome(12, unit, build=build) + lengthChromosome(i, unit, build=build) + 1.25 * ecart),
        orientation = "v",
        legend = FALSE, 
        build=build
      )
      
      text(larg * i,
           lengthChromosome(12, unit, build=build) + 0.75 * ecart,i)
      seg_chr <- ROH[ROH$CHR == i, ]
      
      if (nrow(seg_chr) > 0)
      {
        for (k in 1:nrow(seg_chr)) {
          xx <- c(rep(larg * (i + 0.00), 2), rep(larg * (i + 0.5), 2))
          
          yy <-
            c(
              lengthChromosome(12, unit, build=build) + 1.25 * ecart + abs(
                lengthChromosome(i, unit, build=build) - c(seg_chr[k, pos1], seg_chr[k, pos2])
              ),
              lengthChromosome(12, unit, build=build) + 1.25 * ecart + abs(
                lengthChromosome(i, unit, build=build) - c(seg_chr[k, pos2], seg_chr[k, pos1])
              )
            )
          polygon(
            x  = xx,
            y  = yy,
            col = color(seg_chr$PHE[k]),
            border = color(seg_chr$PHE[k])
          )
        }
      }
      
      
      if (!is.null(regions)) {
        if (nrow(regions) > 0) {
          for (k in 1:nrow(regions)) {
            xx <- c(rep(larg * (i + 0.00), 2), rep(larg * (i + 0.5), 2))
            yy <-
              c(
                lengthChromosome(12, unit, build=build) + 1.25 * ecart + abs(
                  lengthChromosome(i, unit, build=build) - c(reg_chr[k, 2], reg_chr[k, 3])
                ),
                lengthChromosome(12, unit, build=build) + 1.25 * ecart + abs(
                  lengthChromosome(i, unit, build=build) - c(reg_chr[k, 3], reg_chr[k, 2])
                )
              )
            polygon(
              x = xx,
              y = yy,
              border = color2,
              lwd = 2
            )
            
          }
        }
      }
    }
    
    #11 derniers chromosomes
    for (i in 12:22) {
      paintCytobands(
        i,
        units = unit,
        pos   = c(larg * (i - 11), lengthChromosome(i, unit, build=build) +
                    ecart / 4),
        orientation = "v",
        legend = FALSE, 
        build=build
      )
      
      text(larg * (i - 11), -0.25 * ecart, i)
      
      
      seg_chr = ROH[ROH$CHR == i, ]
      
      if (nrow(seg_chr) > 0) {
        for (k in 1:nrow(seg_chr)) {
          xx <- c(rep(larg * (i - 11 + 0.00), 2), rep(larg * (i - 11 + 0.5), 2))
          yy <-
            c(
              0.25 * ecart + abs(
                lengthChromosome(i, unit, build=build) - c(seg_chr[k, pos1], seg_chr[k, pos2])
              ),
              0.25 * ecart + abs(
                lengthChromosome(i, unit, build=build) - c(seg_chr[k, pos2], seg_chr[k, pos1])
              )
            )
          polygon(
            x   = xx,
            y   = yy,
            col = color(seg_chr$PHE[k]),
            border = color(seg_chr$PHE[k])
          )
        }
      }
      if (!is.null(regions)) {
        if (nrow(regions) > 0) {
          if (1:nrow(regions)) {
            for (k in 1:nrow(regions)) {
              xx <- c(rep(larg * (i - 11 + 0.00), 2), rep(larg * (i - 11 + 0.5), 2))
              yy <-
                c(
                  0.25 * ecart + abs(
                    lengthChromosome(i, unit, build=build) - c(reg_chr[k, 2], reg_chr[k, 3])
                  ),
                  0.25 * ecart + abs(
                    lengthChromosome(i, unit, build=build) - c(reg_chr[k, 3], reg_chr[k, 2])
                  )
                )
              polygon(
                x = xx,
                y = yy,
                border = color2,
                lwd = 2
              )
              
            }
          }
        }
      }
      
      
    }
    
  }
