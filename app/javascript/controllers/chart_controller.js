import { Controller } from "@hotwired/stimulus";
import { Chart, LineController, LineElement, PointElement, CategoryScale, LinearScale , Legend } from 'chart.js';
Chart.register(
  LineController,
  LineElement,
  PointElement,
  CategoryScale,
  LinearScale,
  Legend
);

export default class ChartController extends Controller {
  connect() {
    this.render();
  }
  
  render() {
    const element = document.getElementById(this.data.get('id'));
    if (!element) {
      return;
    }
    
    const ctx = element.getContext('2d');
    
    this.graph = new Chart(ctx, {
      type: 'line',
      data: { datasets: this.datasets },
      options: { responsive: true, maintainAspectRatio: false }
    });
  }
  
  get datasets() {
    return [{
      label: 'Highs',
      data: JSON.parse(this.data.get('highs')),
      fill: false,
      borderColor: '#dd7272',
      tension: 0.1
    }, {
      label: 'Lows',
      data: JSON.parse(this.data.get('lows')),
      fill: false,
      borderColor: '#73aae3',
      tension: 0.1
    }];
  }
}