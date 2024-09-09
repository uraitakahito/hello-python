import sys
import os
sys.path.append(os.path.join(os.path.dirname(__file__), os.pardir))
from libs import color

print(color.color_message("Hello, Color!", color.Color.BLUE))
