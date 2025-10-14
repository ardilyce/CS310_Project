import pandas as pd

data = pd.read_csv("urlHaus_original.csv")
links = pd.DataFrame(data.url)
links.to_csv('urls.txt', index=False, header=False)

