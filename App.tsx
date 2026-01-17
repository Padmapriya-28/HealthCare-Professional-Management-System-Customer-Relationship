import { useState } from 'react';
import { Provider } from 'react-redux';
import { Toaster } from 'react-hot-toast';
import { store } from './redux/store';
import { Sidebar } from './components/Sidebar';
import { LogInteractionScreen } from './components/LogInteractionScreen';
import { InteractionsList } from './components/InteractionsList';
import { Dashboard } from './components/Dashboard';
import './index.css';

function App() {
  const [currentPage, setCurrentPage] = useState<'dashboard' | 'log-interaction' | 'interactions-list'>('dashboard');

  const renderPage = () => {
    switch (currentPage) {
      case 'dashboard':
        return <Dashboard />;
      case 'log-interaction':
        return <LogInteractionScreen />;
      case 'interactions-list':
        return <InteractionsList />;
      default:
        return <Dashboard />;
    }
  };

  return (
    <Provider store={store}>
      <div className="flex h-screen bg-gradient-to-br from-slate-50 via-blue-50 to-indigo-50">
        <Sidebar currentPage={currentPage} onPageChange={setCurrentPage} />

        {/* Main Content */}
        <main className="flex-1 overflow-auto pt-16 lg:pt-0">
          <div className="p-6 lg:p-10 max-w-7xl mx-auto">
            {renderPage()}
          </div>
        </main>

        <Toaster position="top-right" />
      </div>
    </Provider>
  );
}

export default App;
