from typing import Dict

import requests
from pandas import DataFrame, read_csv, read_json, to_datetime, json_normalize


def get_public_holidays(public_holidays_url: str, year: str) -> DataFrame:
    """Get the public holidays for the given year for Brazil.

    Args:
        public_holidays_url (str): url to the public holidays.
        year (str): The year to get the public holidays for.

    Raises:
        SystemExit: If the request fails.

    Returns:
        DataFrame: A dataframe with the public holidays.
    """
    # TODO: Implement this function.
    # You must use the requests library to get the public holidays for the given year.
    # The url is public_holidays_url/{year}/BR.
    # You must delete the columns "types" and "counties" from the dataframe.
    # You must convert the "date" column to datetime.
    # You must raise a SystemExit if the request fails. Research the raise_for_status
    # method from the requests library.
    # raise NotImplementedError
    url = public_holidays_url + "/" + year + "/BR"
    try:
        response = requests.get(url)
        response.raise_for_status() #Levanta HTTP error para error     
        data = response.json() 
        df = json_normalize(data)\
            .drop(["types", "counties"], axis=1)\
            .assign(date = lambda x:to_datetime(x["date"], 
                                                format="%Y-%m-%d %H:%M:%S"))
    except requests.exceptions.HTTPError as err:
        raise SystemExit(f"Exiting due to HTTP error: {err}")
    except requests.exceptions.RequestException as err:
        raise SystemExit(f"Exiting due to request exception: {err}")
    
    return df


def extract(
    csv_folder: str, csv_table_mapping: Dict[str, str], public_holidays_url: str
) -> Dict[str, DataFrame]:
    """Extract the data from the csv files and load them into the dataframes.
    Args:
        csv_folder (str): The path to the csv's folder.
        csv_table_mapping (Dict[str, str]): The mapping of the csv file names to the
        table names.
        public_holidays_url (str): The url to the public holidays.
    Returns:
        Dict[str, DataFrame]: A dictionary with keys as the table names and values as
        the dataframes.
    """
    # dataframes = {
    #     table_name: read_csv(f"{csv_folder}/{csv_file}")
    #     for csv_file, table_name in csv_table_mapping.items()
    # }
    dataframes = {}
    for csv_file, table_name in csv_table_mapping.items():
        df = read_csv(f"{csv_folder}/{csv_file}")
        dataframes[table_name] = df
    
    holidays = get_public_holidays(public_holidays_url, "2017")

    dataframes["public_holidays"] = holidays

    return dataframes