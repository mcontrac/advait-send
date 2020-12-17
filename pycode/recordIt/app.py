import pyautogui as pag

time = 1

while True:
    img = pag.screenshot()
    img.save(f"/Users/milindcontractor/advait/recordIt/Photos/img{str(time)}.jpg")
    time = time + 1
