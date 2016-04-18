#! /bin/bash -x

sed 's/,,/,/g' results.txt > fixed.txt
#sed -E 's/\n/,/g' fixed.txt > fixed2.txt
tr '\n' ' ' < fixed.txt > fixed2.txt

# Process test results
IFS=$'\n' read -d '' -r -a lines < fixed2.txt
echo "${lines[@]}" | tr ' ' ',' > fixed3.txt
sed 's/,,/,/g' fixed3.txt > fixed.txt

TEMP=$(mktemp -t chart.XXXXX)

echo $TEMP

# Reading generated output into variable

cat > $TEMP <<EOF
<html>
  <head>
    <!--Load the AJAX API-->
    <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
    <script type="text/javascript">
google.charts.load('current', {'packages':['treemap']});
      google.charts.setOnLoadCallback(drawChart);
      function drawChart() {
        var data = google.visualization.arrayToDataTable([
          ['Location', 'Parent', 'Market trade volume (size)', 'Market increase/decrease (color)'],
          ['Regression',    null,                 0,                               0],
EOF

cat fixed.txt >> $TEMP

cat >> $TEMP <<EOF
        ]);

        tree = new google.visualization.TreeMap(document.getElementById('chart_div'));

        tree.draw(data, {
          minColor: '#f00',
          midColor: '#ddd',
          maxColor: '#0d0',
          headerHeight: 15,
          fontColor: 'black',
          showScale: true
        });

      }
    </script>
  </head>

  <body>
    <!--Div that will hold the pie chart-->
    <div id="chart_div" style="width: 900px; height: 500px;"></div>

  </body>
</html>
EOF

# open browser
case $(uname) in
   Darwin)
      open -a /Applications/Google\ Chrome.app $TEMP
      ;;

   Linux|SunOS)
      firefox $TEMP
      ;;
 esac

