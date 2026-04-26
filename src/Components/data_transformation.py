import os
import sys
from dataclasses import dataclass

from tensorflow.keras.preprocessing.image import ImageDataGenerator

from src.exception import CustomException
from src.logger import logging


@dataclass
class DataTransformationConfig:
    train_dir: str = os.path.join("artifacts", "train")
    test_dir: str = os.path.join("artifacts", "test")
    target_size: tuple = (224, 224)
    batch_size: int = 32


class DataTransformation:
    def __init__(self, train_dir=None, test_dir=None):
        self.config = DataTransformationConfig()

        if train_dir:
            self.config.train_dir = train_dir
        if test_dir:
            self.config.test_dir = test_dir

    def validate_data(self):
        try:
            if not os.path.exists(self.config.train_dir):
                raise Exception("Train folder not found")

            if not os.path.exists(self.config.test_dir):
                raise Exception("Test folder not found")

            # Filter for directories only (class folders)
            classes = [d for d in os.listdir(self.config.train_dir) 
                      if os.path.isdir(os.path.join(self.config.train_dir, d))]

            if len(classes) < 2:
                raise Exception("At least 2 classes required")

            logging.info(f"Classes found: {classes}")

        except Exception as e:
            raise CustomException(e, sys)

    def get_generators(self):
        try:
            train_datagen = ImageDataGenerator(
                rescale=1./255,
                rotation_range=25,
                width_shift_range=0.2,
                height_shift_range=0.2,
                zoom_range=0.2,
                horizontal_flip=True
            )

            test_datagen = ImageDataGenerator(rescale=1./255)

            return train_datagen, test_datagen

        except Exception as e:
            raise CustomException(e, sys)

    def initiate_data_transformation(self):
        try:
            logging.info("Starting data transformation")

            self.validate_data()

            train_gen, test_gen = self.get_generators()

            train_data = train_gen.flow_from_directory(
                self.config.train_dir,
                target_size=self.config.target_size,
                batch_size=self.config.batch_size,
                class_mode='categorical'
            )

            test_data = test_gen.flow_from_directory(
                self.config.test_dir,
                target_size=self.config.target_size,
                batch_size=self.config.batch_size,
                class_mode='categorical'
            )

            logging.info("Data transformation completed")

            return train_data, test_data

        except Exception as e:
            raise CustomException(e, sys)


if __name__ == "__main__":
    from src.Components.data_ingestion import DataIngestion

    ingestion = DataIngestion()
    train_path, test_path = ingestion.initiate_data_ingestion()

    transform = DataTransformation(train_path, test_path)
    train_data, test_data = transform.initiate_data_transformation()

    print("Classes:", train_data.class_indices)