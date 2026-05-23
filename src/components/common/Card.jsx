export default function Card({ children, className = '', hover = true, onClick }) {
  return (
    <div
      onClick={onClick}
      className={`glass rounded-2xl overflow-hidden transition-all duration-300 ${
        hover
          ? 'hover:shadow-lg hover:shadow-primary-900/20 hover:-translate-y-0.5 hover:border-primary-700/30'
          : ''
      } ${onClick ? 'cursor-pointer' : ''} ${className}`}
    >
      {children}
    </div>
  );
}

export function CardHeader({ children, className = '' }) {
  return (
    <div className={`px-5 sm:px-6 py-4 border-b border-surface-600/30 ${className}`}>
      {children}
    </div>
  );
}

export function CardBody({ children, className = '' }) {
  return <div className={`px-5 sm:px-6 py-4 sm:py-5 ${className}`}>{children}</div>;
}

export function CardFooter({ children, className = '' }) {
  return (
    <div className={`px-5 sm:px-6 py-4 border-t border-surface-600/30 ${className}`}>
      {children}
    </div>
  );
}
