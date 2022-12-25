import { useState, useRef } from "react";
import initSqlJs from "sql.js";
import fs from "fs";

export default function Main(props) {
  // console.log(props.request[0]);
  const [threshold, setThreshold] = useState(10000);

  const inputRef_threshold = useRef();
  const data = {
    columns: props.request[0].columns,
    values: props.request[0].values,
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    setThreshold(inputRef_threshold.current.value);
  };

  return (
    <div className="container">
      <h1 className="title">Price Anomaly</h1>
      <table>
        <thead>
          <tr>
            {data.columns.map((column) => (
              <th key={column}>{column}</th>
            ))}
          </tr>
        </thead>
        <tbody>
          {data.values.map(
            (row) =>
              Math.abs(row[2]) < threshold && (
                <tr key={row[0]}>
                  {row.map((cell) => (
                    <td key={cell}>{cell}</td>
                  ))}
                </tr>
              )
          )}
        </tbody>
      </table>
      <form id="userAnomalySetting" onSubmit={handleSubmit}>
        <label htmlFor="threshold">Set a positive value for the num_stddev (It will change how many standard deviations a data point from the mean is considered abnormal)</label>
        <input type="number" name="threshold" min={"0"} ref={inputRef_threshold} />
        <input type="submit" id="submit" value="Submit" />
      </form>

      <p style={{ position: "absolute", bottom: "10px" }}>Note : the values with id 1 and 2 are used for test only, they are faked</p>
    </div>
  );
}

export async function getStaticProps() {
  const SQL = await initSqlJs();
  const filebuffer = fs.readFileSync("database/anomaly_db");
  const db = new SQL.Database(filebuffer);
  const request = db.exec("Select * from price_anomaly");
  return { props: { request } };
}
