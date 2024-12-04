class PV:
    def __init__(self):
        self.aistor_pv_size = None
        self.hostnames = None

    def create_JSON(self):
        print(f"Hello, my name is {self.name} and I am {self.age} years old")

def retrieve_pv_size():
    with open("./main.tf", "r") as file:
        lines = file.readlines()
        for line in lines:
            if "ebs_storage_volume_size" in line:
                pv_size = line.split("=")[1].strip()
                return pv_size

def main():
    # Create PV object
    pv = PV()

    # Populate Variables
    pv.aistor_pv_size = retrieve_pv_size()

    
    # Check
    print(pv.aistor_pv_size)


if __name__ == '__main__':
    main()