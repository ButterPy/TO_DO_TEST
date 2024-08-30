import multiprocessing

bind = '0.0.0.0:8080'
preload_app = True
workers = multiprocessing.cpu_count() * 2 + 1
timeout = 40
reload = True
