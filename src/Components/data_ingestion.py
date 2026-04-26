import os
import sys
import shutil
import random
from dataclasses import dataclass

from src.exception import CustomException
from src.logger import logging


@dataclass
class DataIngestionConfig:
    train_path: str = os.path.join("artifacts", "train")
    test_path: str = os.path.join("artifacts", "test")


class DataIngestion:
    def __init__(self):
        self.config = DataIngestionConfig()

    def split_data(self, source_dir, train_dir, test_dir, split_ratio=0.8):
        try:
            os.makedirs(train_dir, exist_ok=True)
            os.makedirs(test_dir, exist_ok=True)

            images = [f for f in os.listdir(source_dir)
                      if os.path.isfile(os.path.join(source_dir, f))
                      and f.lower().endswith(('.jpg', '.jpeg', '.png'))]

            random.shuffle(images)
            split_index = int(len(images) * split_ratio)

            train_files = images[:split_index]
            test_files = images[split_index:]

            for file in train_files:
                shutil.copy2(os.path.join(source_dir, file),
                             os.path.join(train_dir, file))

            for file in test_files:
                shutil.copy2(os.path.join(source_dir, file),
                             os.path.join(test_dir, file))

            logging.info(f"{source_dir} → Train: {len(train_files)}, Test: {len(test_files)}")

        except Exception as e:
            raise CustomException(e, sys)

    def initiate_data_ingestion(self):
        logging.info("Starting data ingestion for food freshness dataset")

        try:
            dataset_root = "dataset"
            train_source = os.path.join(dataset_root, "Train")

            if not os.path.exists(train_source):
                raise Exception(f"Dataset folder not found at {train_source}")

            # Loop through fruit classes in the Train folder
            for fruit_class in os.listdir(train_source):
                class_path = os.path.join(train_source, fruit_class)

                if not os.path.isdir(class_path):
                    continue

                logging.info(f"Processing class: {fruit_class}")

                train_class_path = os.path.join(self.config.train_path, fruit_class)
                test_class_path = os.path.join(self.config.test_path, fruit_class)

                self.split_data(class_path, train_class_path, test_class_path)

            logging.info("Data ingestion completed successfully")

            return self.config.train_path, self.config.test_path

        except Exception as e:
            raise CustomException(e, sys)


if __name__ == "__main__":
    obj = DataIngestion()
    train_path, test_path = obj.initiate_data_ingestion()
    print("Train Path:", train_path)
    print("Test Path:", test_path)