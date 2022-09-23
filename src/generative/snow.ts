import { Point, randomize, pathFromPoints, svgPartFromPath, svgFromBody, svgImageFromSvg } from "@/models/point";

const generatePoints = (
  style: number,
  thickness: number,
) => {
  const points: Point[] = [];
  const [cx, cy] = [512, 512];
  const r0 = 280;
  points.push({
    x: cx,
    y: cy,
    c: true,
    r: 0    
  });
  points.push({
    x: cx,
    y: cy + r0,
    c: true,
    r: 0    
  });
  const army = thickness;
  const armx = army * 1.73;
  const dir = (style > 2) ? -1 : 1;
  for (let r = r0, f = 1; r > 0; r -= army, f = (f % 2) + 1) {
    points.push({
      x: cx + armx * f,
      y: cy + r + dir * army * f,
      c: false,
      r: 1    
    });
    points.push({
      x: cx + armx * f,
      y: cy + r - army + dir * army * f,
      c: false,
      r: 1    
    });
  }
  points.push({
    x: cx + armx,
    y: cy + army,
    c: true,
    r: 0    
  });
  return points;
};

export const generateSVGImage = (color: string) => {
  const points = generatePoints(
    randomize(2, 0.5),
    randomize(30, 0.5),
  );
  const path = pathFromPoints(points);
  const uses = Array(6).fill(0).map((v, index) => {
    return `<use href="#asset" fill="${color}" transform="rotate(${index * 60}, 512, 512)" />\n`
    + `<use href="#asset" fill="${color}" transform="rotate(${index * 60}, 512, 512) scale(-1, 1) translate(-1024, 0) " />\n`;

  }).join('');
  const svg = svgFromBody(svgPartFromPath(path, "asset") + uses);
  return svgImageFromSvg(svg);
};
