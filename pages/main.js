import { useEffect, useState } from "react";
import initSqlJs from "sql.js";
import fs from "fs";

export default function Main(props) {
  // console.log(props.request[0]);
  const data = {
    columns: props.request[0].columns,
    values: props.request[0].values,
  };
  return (
    <table>
      <thead>
        <tr>
          {data.columns.map((column) => (
            <th key={column}>{column}</th>
          ))}
        </tr>
      </thead>
      <tbody>
        {data.values.map((row) => (
          <tr key={row[0]}>
            {row.map((cell) => (
              <td key={cell}>{cell}</td>
            ))}
          </tr>
        ))}
      </tbody>
    </table>
  );
}

export async function getStaticProps() {
  const SQL = await initSqlJs();
  const filebuffer = fs.readFileSync("database/anomaly_db");
  const db = new SQL.Database(filebuffer);
  const request = db.exec("Select * from price_anomaly");
  return { props: { request } };
}
