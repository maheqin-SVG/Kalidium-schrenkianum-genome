library(readr)
library(dplyr)
library(ggplot2)

df <- read_tsv(
  "Ksch.LTR_identity.tsv",
  show_col_types = FALSE
)

mu <- 7.54e-9

df <- df %>%
  mutate(
    Identity = as.numeric(Identity),
    Mya = (1 - Identity) / (2 * mu) / 1e6,
    Type = factor(Type, levels = c("Copia", "Gypsy"))
  ) %>%
  filter(
    Type %in% c("Copia", "Gypsy"),
    is.finite(Mya),
    !is.na(Mya),
    Mya >= 0
  )

write_tsv(
  df,
  "Ksch.LTR_insertion_time.tsv"
)

summary_df <- df %>%
  group_by(Type) %>%
  summarise(
    Number = n(),
    Median_Mya = median(Mya),
    Within_1_Mya = mean(Mya <= 1) * 100,
    Within_3_Mya = mean(Mya <= 3) * 100,
    .groups = "drop"
  )

write_tsv(
  summary_df,
  "Ksch.LTR_insertion_time_summary.tsv"
)

p <- ggplot(
  df,
  aes(x = Mya, fill = Type)
) +
  geom_density(
    alpha = 0.65,
    linewidth = 0,
    adjust = 1
  ) +
  scale_fill_manual(
    values = c(
      "Copia" = "#B5EAD7",
      "Gypsy" = "#FFB7B2"
    )
  ) +
  scale_x_continuous(
    limits = c(0, 5),
    breaks = c(0, 2.5, 5),
    expand = c(0, 0)
  ) +
  scale_y_continuous(
    limits = c(0, 0.85),
    breaks = seq(0, 0.8, 0.2),
    expand = c(0, 0)
  ) +
  labs(
    x = "LTR-RT insertion time (Million Year Ago)",
    y = "Density"
  ) +
  theme_classic(base_size = 16) +
  theme(
    axis.title.x = element_text(size = 17, margin = margin(t = 10)),
    axis.title.y = element_text(size = 17, margin = margin(r = 10)),
    axis.text = element_text(size = 14, color = "black"),
    axis.line = element_line(linewidth = 0.8, color = "black"),
    axis.ticks = element_line(linewidth = 0.8, color = "black"),
    legend.title = element_blank(),
    legend.position = c(0.84, 0.27),
    legend.text = element_text(size = 14, face = "italic"),
    legend.key.height = grid::unit(0.55, "cm"),
    legend.key.width = grid::unit(0.55, "cm"),
    panel.border = element_rect(
      color = "black",
      fill = NA,
      linewidth = 0.8
    ),
    panel.grid = element_blank(),
    plot.margin = margin(10, 15, 10, 10)
  )

print(p)

ggsave(
  "Ksch.LTR_insertion_time_density.pdf",
  p,
  width = 6,
  height = 5
)

ggsave(
  "Ksch.LTR_insertion_time_density.png",
  p,
  width = 6,
  height = 5,
  dpi = 600
)
