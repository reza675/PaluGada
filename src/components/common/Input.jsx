import { useState } from 'react';

export default function Input({
  label,
  id,
  type = 'text',
  placeholder,
  value,
  onChange,
  error,
  required = false,
  disabled = false,
  className = '',
  rows,
  options,
  ...props
}) {
  const [focused, setFocused] = useState(false);

  const baseInputClasses = `w-full bg-surface-800/50 border rounded-xl px-4 py-3 text-surface-50 placeholder-surface-500 
    transition-all duration-300 focus:outline-none focus:ring-2 focus:ring-primary-500/50 focus:border-primary-500
    ${error ? 'border-red-500' : focused ? 'border-primary-500' : 'border-surface-600'}
    ${disabled ? 'opacity-50 cursor-not-allowed' : ''}`;

  const renderInput = () => {
    if (type === 'textarea') {
      return (
        <textarea
          id={id}
          value={value}
          onChange={onChange}
          placeholder={placeholder}
          required={required}
          disabled={disabled}
          rows={rows || 4}
          onFocus={() => setFocused(true)}
          onBlur={() => setFocused(false)}
          className={`${baseInputClasses} resize-none`}
          {...props}
        />
      );
    }

    if (type === 'select') {
      return (
        <select
          id={id}
          value={value}
          onChange={onChange}
          required={required}
          disabled={disabled}
          onFocus={() => setFocused(true)}
          onBlur={() => setFocused(false)}
          className={`${baseInputClasses} cursor-pointer`}
          {...props}
        >
          <option value="" className="bg-surface-800">{placeholder || 'Pilih...'}</option>
          {options?.map((opt) => (
            <option key={opt.value} value={opt.value} className="bg-surface-800">
              {opt.label}
            </option>
          ))}
        </select>
      );
    }

    return (
      <input
        id={id}
        type={type}
        value={value}
        onChange={onChange}
        placeholder={placeholder}
        required={required}
        disabled={disabled}
        onFocus={() => setFocused(true)}
        onBlur={() => setFocused(false)}
        className={baseInputClasses}
        {...props}
      />
    );
  };

  return (
    <div className={`space-y-1.5 ${className}`}>
      {label && (
        <label htmlFor={id} className="block text-sm font-medium text-surface-300">
          {label}
          {required && <span className="text-primary-400 ml-1">*</span>}
        </label>
      )}
      {renderInput()}
      {error && <p className="text-sm text-red-400 mt-1">{error}</p>}
    </div>
  );
}
