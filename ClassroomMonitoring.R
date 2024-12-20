# Load required libraries

library(tidyverse)
library(gganimate)

#Parameters of rescorla-wagner model and specific simulation
num_trials <- 150  # Number of trials to simulate
alpha <- 0.1  # learning rate
beta <- 1     # salience of the punishment
lambda <- 1   # maximum associative strength
V <- 0        # initial associative strength

# Vectors to store results
interruptions <- rep(0, num_trials)
associative_strength <- rep(0, num_trials)

# Simulate the Learning Process
for (t in 1:num_trials) {
  # Child's interruption behavior (if they interrupt 80% of the time originally)
  interrupt_prob <- 0.8 - 0.5 * V  # As the associative strength increases, interruptions decrease
  interruptions[t] <- rbinom(1, 1, interrupt_prob)  # Simulate whether the child interrupts
  
  # If child interrupts, apply the Rescorla-Wagner model update rule
  if (interruptions[t] == 1) {
    delta_V <- alpha * beta * (lambda - V)  # Change in associative strength
    V <- V + delta_V  # Update the associative strength
  }
  
  # Store the current associative strength (V) for later analysis
  associative_strength[t] <- V
}

# Create a data frame to hold the results for plotting
data <- data.frame(
  Trial = 1:num_trials,
  AssociativeStrength = associative_strength
)

# Static plot using ggplot2
p <- ggplot(data, aes(x = Trial, y = AssociativeStrength)) +
  geom_line(color = "blue", size = 1.5) +
  geom_point(color = "limegreen") +
  labs(
    title = "Associative Strength Over Time",
    x = "Trial (Day)",
    y = "Associative Strength (V)"
  ) +
  theme_minimal()


# Animate the plot using gganimate
animated_plot <- p +
  transition_reveal(Trial) +  # Reveal the plot over time (based on 'Trial')
  labs(title = "Associative Strength of Classroom Management")  # Dynamic title with trial number

# Render the animation
animate(animated_plot, nframes = num_trials, fps = 20, width = 900, height = 600)

# Save the animation
anim_save("classroom_associative_strength.gif")