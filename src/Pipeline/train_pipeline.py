import os
import sys

from src.Components.data_ingestion import DataIngestion
from src.Components.data_transformation import DataTransformation
from src.Components.model_trainer import ModelTrainer
from src.exception import CustomException
from src.logger import logging


class TrainPipeline:
    def __init__(self):
        self.data_ingestion = DataIngestion()
        self.data_transformation = DataTransformation()
        self.model_trainer = ModelTrainer()

    def run(self):
        """Execute complete training pipeline"""
        try:
            logging.info("="*50)
            logging.info("Starting Food Freshness Classification Pipeline")
            logging.info("="*50)

            # Step 1: Data Ingestion
            logging.info("STEP 1: Data Ingestion")
            train_path, test_path = self.data_ingestion.initiate_data_ingestion()

            # Step 2: Data Transformation
            logging.info("STEP 2: Data Transformation")
            self.data_transformation = DataTransformation(train_path, test_path)
            train_data, test_data = self.data_transformation.initiate_data_transformation()

            # Step 3: Model Training
            logging.info("STEP 3: Model Training")
            model, history = self.model_trainer.initiate_model_trainer(train_data, test_data)

            logging.info("="*50)
            logging.info("Pipeline completed successfully!")
            logging.info("="*50)

            return model, history

        except Exception as e:
            raise CustomException(e, sys)


if __name__ == "__main__":
    pipeline = TrainPipeline()
    model, history = pipeline.run()
