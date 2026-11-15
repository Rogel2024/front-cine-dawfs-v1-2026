FROM node:20-alpine as build

#ENV NODE_ENV=production

WORKDIR /app

COPY package*.json .

RUN npm ci --legacy-peer-deps

# RUN npm install typescript 

COPY . .

ARG VITE_API_URL
ENV VITE_API_URL=$VITE_API_URL

#RUN npm run build -- --mode prod
RUN npm run build

#FROM nginxinc/nginx-unprivileged:1.28-alpine as production

#USER root

#RUN rm -f /etc/nginx/conf.d/default.conf

#COPY nginx/frontend.conf /etc/nginx/conf.d/frontend.conf
FROM nginx:1.31.8
COPY nginx/frontend.conf /etc/nginx/conf.d/default.conf → COPY nginx/nginx.conf /etc/nginx/conf.d/default.conf
##COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

#USER nginx

#HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
#CMD wget -q --spider http://127.0.0.1/ || exit 1