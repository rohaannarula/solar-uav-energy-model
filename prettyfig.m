function prettyfig(h)

if nargin < 1
    h = gcf;
end

set(h, 'Color', 'w');

ax = findall(h, 'Type', 'axes');
set(ax, 'Color', 'w', 'XColor', 'k', 'YColor', 'k');

set(findall(h, 'Type', 'text'), 'Color', 'k');

set(findall(h, '-property', 'FontSize'), 'FontSize', 11);

end