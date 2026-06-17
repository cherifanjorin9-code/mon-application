// ============================================
// KUIZINE — Admin Financial Reports
// ============================================

import Store from '../store.js';
import { renderAdminShell, bindAdminShellEvents, adminFormatPrice, formatAdminDate, drawBarChart } from './components.js';

let period = 'week';

export function renderAdminReports() {
  const app = document.getElementById('app');

  // Get orders for selected period
  let orders;
  let periodLabel;
  switch (period) {
    case 'day':
      orders = Store.getTodayOrders();
      periodLabel = "Aujourd'hui";
      break;
    case 'month':
      orders = Store.getMonthOrders();
      periodLabel = 'Ce mois (30j)';
      break;
    case 'week':
    default:
      orders = Store.getWeekOrders();
      periodLabel = 'Cette semaine (7j)';
  }

  const validOrders = orders.filter(o => o.status !== 'cancelled');
  const totalRevenue = validOrders.reduce((sum, o) => sum + o.total, 0);
  const totalMargin = Math.round(totalRevenue * 0.04);
  const orderCount = validOrders.length;
  const avgBasket = orderCount > 0 ? Math.round(totalRevenue / orderCount) : 0;

  // Chart data
  let chartLabels = [];
  let chartData = [];
  const allOrders = Store.getOrders();

  if (period === 'day') {
    // Hours of today
    for (let h = 0; h < 24; h += 3) {
      const today = new Date();
      today.setHours(h, 0, 0, 0);
      const next = new Date(today);
      next.setHours(h + 3);
      const count = allOrders.filter(o => {
        const d = new Date(o.date);
        return d >= today && d < next && o.status !== 'cancelled';
      }).length;
      chartLabels.push(`${h}h`);
      chartData.push(count);
    }
  } else if (period === 'week') {
    for (let i = 6; i >= 0; i--) {
      const d = new Date();
      d.setDate(d.getDate() - i);
      d.setHours(0, 0, 0, 0);
      const next = new Date(d);
      next.setDate(next.getDate() + 1);
      const count = allOrders.filter(o => {
        const od = new Date(o.date);
        return od >= d && od < next && o.status !== 'cancelled';
      }).length;
      chartLabels.push(d.toLocaleDateString('fr-FR', { weekday: 'short' }));
      chartData.push(count);
    }
  } else {
    // Monthly - by week
    for (let i = 3; i >= 0; i--) {
      const end = new Date();
      end.setDate(end.getDate() - (i * 7));
      end.setHours(23, 59, 59, 999);
      const start = new Date(end);
      start.setDate(start.getDate() - 7);
      start.setHours(0, 0, 0, 0);
      const count = allOrders.filter(o => {
        const d = new Date(o.date);
        return d >= start && d <= end && o.status !== 'cancelled';
      }).length;
      chartLabels.push(`S-${i}`);
      chartData.push(count);
    }
  }

  const content = `
    <!-- Period Selector -->
    <div class="admin-filters" style="justify-content: space-between;">
      <div class="report-period-selector">
        <div class="tabs">
          <button class="tab ${period === 'day' ? 'active' : ''}" data-period="day">Jour</button>
          <button class="tab ${period === 'week' ? 'active' : ''}" data-period="week">Semaine</button>
          <button class="tab ${period === 'month' ? 'active' : ''}" data-period="month">Mois</button>
        </div>
      </div>
      <div class="report-export-actions">
        <button class="btn btn-secondary btn-sm" id="btn-export-csv">📥 Export CSV</button>
        <button class="btn btn-secondary btn-sm" id="btn-print">🖨️ Imprimer</button>
      </div>
    </div>

    <!-- Stats Cards -->
    <div class="stats-grid" style="margin-bottom: var(--space-2xl);">
      <div class="stat-card">
        <div class="stat-card-icon" style="background: #DCFCE7; color: var(--success);">💰</div>
        <div class="stat-card-content">
          <div class="stat-card-label">Revenu total</div>
          <div class="stat-card-value">${adminFormatPrice(totalRevenue)}</div>
          <div class="stat-card-trend">${periodLabel}</div>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-card-icon" style="background: #F3E8FF; color: #9333EA;">📈</div>
        <div class="stat-card-content">
          <div class="stat-card-label">Marge totale (~4%)</div>
          <div class="stat-card-value">${adminFormatPrice(totalMargin)}</div>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-card-icon" style="background: #FFF7ED; color: var(--primary);">📦</div>
        <div class="stat-card-content">
          <div class="stat-card-label">Commandes</div>
          <div class="stat-card-value">${orderCount}</div>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-card-icon" style="background: #DBEAFE; color: var(--info);">🛒</div>
        <div class="stat-card-content">
          <div class="stat-card-label">Panier moyen</div>
          <div class="stat-card-value">${adminFormatPrice(avgBasket)}</div>
        </div>
      </div>
    </div>

    <!-- Chart -->
    <div class="chart-card" style="margin-bottom: var(--space-2xl);">
      <div class="chart-card-header">
        <h3 class="chart-card-title">📊 Évolution des commandes — ${periodLabel}</h3>
      </div>
      <div class="chart-container">
        <canvas id="report-chart"></canvas>
      </div>
    </div>

    <!-- Orders Table -->
    <div class="chart-card">
      <div class="chart-card-header">
        <h3 class="chart-card-title">📋 Détail des commandes</h3>
      </div>
      ${validOrders.length > 0 ? `
        <div class="table-container" style="box-shadow:none; border:none;">
          <table class="table" id="report-table">
            <thead>
              <tr>
                <th>N°</th>
                <th>Date</th>
                <th>Client</th>
                <th>Articles</th>
                <th>Montant</th>
                <th>Marge (~4%)</th>
                <th>Paiement</th>
              </tr>
            </thead>
            <tbody>
              ${validOrders.map(o => `
                <tr>
                  <td><strong>${o.id}</strong></td>
                  <td style="white-space:nowrap;">${formatAdminDate(o.date)}</td>
                  <td>${o.customer.name}</td>
                  <td>${o.items.length}</td>
                  <td><strong>${adminFormatPrice(o.total)}</strong></td>
                  <td style="color: var(--success);">${adminFormatPrice(Math.round(o.total * 0.04))}</td>
                  <td>${o.paymentMethod === 'cash' ? '💵' : '📱'} ${o.paymentMethod}</td>
                </tr>
              `).join('')}
            </tbody>
            <tfoot>
              <tr style="font-weight:700; background: #FAFAF9;">
                <td colspan="4">TOTAL</td>
                <td>${adminFormatPrice(totalRevenue)}</td>
                <td style="color: var(--success);">${adminFormatPrice(totalMargin)}</td>
                <td></td>
              </tr>
            </tfoot>
          </table>
        </div>
      ` : `
        <div style="text-align:center; color:var(--text-muted); padding: var(--space-xl); font-size: var(--font-size-sm);">
          Aucune commande pour cette période
        </div>
      `}
    </div>
  `;

  app.innerHTML = renderAdminShell('Rapports financiers', content);
  bindAdminShellEvents();

  // Draw chart
  setTimeout(() => {
    drawBarChart('report-chart', chartLabels, chartData, '#16A34A');
  }, 100);

  // Period tabs
  document.querySelectorAll('[data-period]').forEach(tab => {
    tab.addEventListener('click', () => {
      period = tab.dataset.period;
      renderAdminReports();
    });
  });

  // Export CSV
  document.getElementById('btn-export-csv')?.addEventListener('click', () => {
    let csv = 'N°,Date,Client,Téléphone,Adresse,Articles,Montant,Marge,Paiement\n';
    validOrders.forEach(o => {
      csv += `${o.id},"${formatAdminDate(o.date)}","${o.customer.name}","${o.customer.phone}","${o.customer.address}",${o.items.length},${o.total},${Math.round(o.total * 0.04)},${o.paymentMethod}\n`;
    });

    const blob = new Blob(['\uFEFF' + csv], { type: 'text/csv;charset=utf-8;' });
    const url = URL.createObjectURL(blob);
    const link = document.createElement('a');
    link.href = url;
    link.download = `kuizine_rapport_${period}_${new Date().toISOString().slice(0,10)}.csv`;
    link.click();
    URL.revokeObjectURL(url);
    Store._showToast('Rapport exporté en CSV 📥', 'success');
  });

  // Print
  document.getElementById('btn-print')?.addEventListener('click', () => {
    window.print();
  });
}
