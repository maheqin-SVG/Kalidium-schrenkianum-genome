library(tidyverse)
library(patchwork)
library(ggpointdensity)

df <- read_tsv(
  "Ksch.final.clean.10kb.GC_depth.q20.tsv",
  show_col_types = FALSE
)

df_plot <- df %>%
  filter(
    is.finite(GC_percent),
    is.finite(Mean_depth),
    between(GC_percent, 0, 70),
    between(Mean_depth, 0, 120)
  )

p_main <- ggplot(df_plot, aes(GC_percent, Mean_depth)) +
  geom_pointdensity(
    method = "kde2d",
    adjust = 0.7,
    size = 0.55
  ) +
  scale_color_viridis_c(
    option = "viridis",
    guide = "none"
  ) +
  scale_x_continuous(
    limits = c(0, 70),
    breaks = c(0, 20, 40, 60),
    expand = c(0, 0)
  ) +
  scale_y_continuous(
    limits = c(0, 120),
    breaks = seq(0, 120, 20),
    expand = c(0, 0)
  ) +
  labs(
    x = "GC content (%)",
    y = "Mean HiFi sequencing depth"
  ) +
  theme_classic(base_size = 14) +
  theme(
    axis.title = element_text(size = 15),
    axis.text = element_text(size = 11),
    axis.line = element_line(linewidth = 0.6),
    axis.ticks = element_line(linewidth = 0.5),
    plot.margin = margin(2, 2, 5, 5)
  )

p_top <- ggplot(df_plot, aes(GC_percent)) +
  geom_histogram(
    binwidth = 0.5,
    boundary = 0,
    fill = "white",
    color = "black",
    linewidth = 0.30
  ) +
  scale_x_continuous(
    limits = c(0, 70),
    breaks = c(0, 20, 40, 60),
    expand = c(0, 0)
  ) +
  labs(x = NULL, y = NULL) +
  theme_classic(base_size = 12) +
  theme(
    axis.text.x = element_blank(),
    axis.ticks.x = element_blank(),
    axis.title = element_blank(),
    plot.margin = margin(5, 2, 0, 5)
  )

p_right <- ggplot(df_plot, aes(y = Mean_depth)) +
  geom_histogram(
    binwidth = 5,
    boundary = 0,
    orientation = "y",
    fill = "white",
    color = "black",
    linewidth = 0.35
  ) +
  scale_y_continuous(
    limits = c(0, 120),
    breaks = seq(0, 120, 20),
    expand = c(0, 0)
  ) +
  labs(x = NULL, y = NULL) +
  theme_classic(base_size = 12) +
  theme(
    axis.text.y = element_blank(),
    axis.ticks.y = element_blank(),
    axis.title = element_blank(),
    plot.margin = margin(2, 5, 5, 0)
  )

p_final <- (
  p_top + plot_spacer()
) /
  (
    p_main + p_right
  ) +
  plot_layout(
    widths = c(8, 1.15),
    heights = c(1.2, 4.8)
  )

ggsave(
  "Ksch.GC_HiFi_depth_joint_distribution.pdf",
  p_final,
  width = 7,
  height = 7
)
