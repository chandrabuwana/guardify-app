# Angular & Nx Proxy Configuration Guide

## Overview
Proxy configuration in Angular/Nx allows you to redirect API calls during development without CORS issues. This guide covers setup, configuration, and best practices.

---

## 1. Basic Proxy Setup in Nx

### 1.1 Create Proxy Configuration File

Create `proxy.conf.json` in your project root:

```json
{
  "/api": {
    "target": "https://api-devguardify.abb-apps.com",
    "secure": false,
    "changeOrigin": true,
    "pathRewrite": {
      "^/api": "/api/v1"
    },
    "logLevel": "debug"
  },
  "/hubs": {
    "target": "https://api-devguardify.abb-apps.com",
    "secure": false,
    "changeOrigin": true,
    "ws": true
  }
}
```

### 1.2 Configure in `angular.json`

```json
{
  "projects": {
    "your-app": {
      "architect": {
        "serve": {
          "builder": "@angular-devkit/build-angular:dev-server",
          "options": {
            "browserTarget": "your-app:build",
            "proxyConfig": "proxy.conf.json"
          }
        }
      }
    }
  }
}
```

### 1.3 Run with Proxy

```bash
ng serve --proxy-config proxy.conf.json
# or
nx serve your-app --proxy-config proxy.conf.json
```

---

## 2. Environment-Based Proxy Configuration

### 2.1 Multiple Proxy Configs

**proxy.conf.dev.json** (Development):
```json
{
  "/api": {
    "target": "https://api-devguardify.abb-apps.com",
    "secure": false,
    "changeOrigin": true
  }
}
```

**proxy.conf.prod.json** (Production):
```json
{
  "/api": {
    "target": "https://api-guardify.abb-apps.com",
    "secure": true,
    "changeOrigin": true
  }
}
```

### 2.2 Update `angular.json`

```json
{
  "serve": {
    "configurations": {
      "development": {
        "proxyConfig": "proxy.conf.dev.json"
      },
      "production": {
        "proxyConfig": "proxy.conf.prod.json"
      }
    }
  }
}
```

### 2.3 Run with Configuration

```bash
ng serve --configuration development
ng serve --configuration production
```

---

## 3. Nx Workspace Proxy Configuration

### 3.1 Shared Proxy for Multiple Apps

Create `tools/proxy/proxy.conf.json`:

```json
{
  "/api": {
    "target": "https://api-devguardify.abb-apps.com",
    "secure": false,
    "changeOrigin": true,
    "pathRewrite": {
      "^/api": "/api/v1"
    }
  },
  "/auth": {
    "target": "https://api-devguardify.abb-apps.com",
    "secure": false,
    "changeOrigin": true
  }
}
```

### 3.2 Reference in Each App's `angular.json`

```json
{
  "projects": {
    "app1": {
      "architect": {
        "serve": {
          "options": {
            "proxyConfig": "tools/proxy/proxy.conf.json"
          }
        }
      }
    },
    "app2": {
      "architect": {
        "serve": {
          "options": {
            "proxyConfig": "tools/proxy/proxy.conf.json"
          }
        }
      }
    }
  }
}
```

---

## 4. Advanced Proxy Configuration

### 4.1 Multiple Targets with Path Rewriting

```json
{
  "/api/v1": {
    "target": "https://api-devguardify.abb-apps.com",
    "secure": false,
    "changeOrigin": true
  },
  "/auth": {
    "target": "https://auth-service.abb-apps.com",
    "secure": false,
    "changeOrigin": true
  },
  "/files": {
    "target": "https://file-service.abb-apps.com",
    "secure": false,
    "changeOrigin": true,
    "pathRewrite": {
      "^/files": "/upload"
    }
  },
  "/hubs": {
    "target": "https://api-devguardify.abb-apps.com",
    "secure": false,
    "changeOrigin": true,
    "ws": true
  }
}
```

### 4.2 Custom Middleware for Proxy

Create `proxy.middleware.js`:

```javascript
module.exports = (req, res, next) => {
  // Add custom headers
  req.headers['X-Custom-Header'] = 'custom-value';
  
  // Log requests
  console.log(`[PROXY] ${req.method} ${req.url}`);
  
  // Conditional routing
  if (req.url.includes('/admin')) {
    req.headers['Authorization'] = `Bearer ${process.env.ADMIN_TOKEN}`;
  }
  
  next();
};
```

Update `proxy.conf.json`:

```json
{
  "/api": {
    "target": "https://api-devguardify.abb-apps.com",
    "secure": false,
    "changeOrigin": true,
    "onProxyReq": "proxy.middleware.js"
  }
}
```

---

## 5. Proxy Configuration for Different Environments

### 5.1 Environment Service Approach

**environment.ts** (Development):
```typescript
export const environment = {
  production: false,
  apiUrl: '/api',  // Uses proxy
  apiBaseUrl: 'https://api-devguardify.abb-apps.com/api/v1'
};
```

**environment.prod.ts** (Production):
```typescript
export const environment = {
  production: true,
  apiUrl: 'https://api-guardify.abb-apps.com/api/v1',  // Direct URL
  apiBaseUrl: 'https://api-guardify.abb-apps.com/api/v1'
};
```

### 5.2 HTTP Interceptor with Proxy

```typescript
import { Injectable } from '@angular/core';
import { HttpInterceptor, HttpRequest, HttpHandler, HttpEvent } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../environments/environment';

@Injectable()
export class ProxyInterceptor implements HttpInterceptor {
  intercept(req: HttpRequest<any>, next: HttpHandler): Observable<HttpEvent<any>> {
    // In development, use proxy; in production, use full URL
    if (!environment.production && !req.url.startsWith('http')) {
      const proxyUrl = environment.apiUrl + req.url;
      req = req.clone({ url: proxyUrl });
    }
    
    return next.handle(req);
  }
}
```

---

## 6. WebSocket Proxy Configuration

### 6.1 SignalR/WebSocket Setup

```json
{
  "/hubs": {
    "target": "https://api-devguardify.abb-apps.com",
    "secure": false,
    "changeOrigin": true,
    "ws": true,
    "logLevel": "debug"
  }
}
```

### 6.2 Angular Service for WebSocket

```typescript
import { Injectable } from '@angular/core';
import * as signalR from '@microsoft/signalr';
import { environment } from '../environments/environment';

@Injectable({ providedIn: 'root' })
export class SignalRService {
  private connection: signalR.HubConnection;

  connect(): Promise<void> {
    const url = environment.production
      ? 'https://api-guardify.abb-apps.com/hubs/chat'
      : '/hubs/chat';  // Uses proxy in development

    this.connection = new signalR.HubConnectionBuilder()
      .withUrl(url)
      .withAutomaticReconnect()
      .build();

    return this.connection.start();
  }
}
```

---

## 7. Debugging Proxy Issues

### 7.1 Enable Proxy Logging

```json
{
  "/api": {
    "target": "https://api-devguardify.abb-apps.com",
    "secure": false,
    "changeOrigin": true,
    "logLevel": "debug"
  }
}
```

### 7.2 Common Issues & Solutions

| Issue | Cause | Solution |
|-------|-------|----------|
| 404 Not Found | Path mismatch | Check `pathRewrite` rules |
| CORS Error | `changeOrigin: false` | Set `changeOrigin: true` |
| SSL Error | `secure: false` | Set `secure: true` for HTTPS |
| WebSocket fails | Missing `ws: true` | Add `"ws": true` for WebSocket |
| Headers lost | Proxy strips headers | Use `onProxyReq` middleware |

### 7.3 Check Network Tab

1. Open DevTools → Network tab
2. Look for requests to `/api`
3. Check if they're being proxied correctly
4. Verify response headers

---

## 8. Best Practices

### 8.1 Development vs Production

```typescript
// ✅ GOOD: Conditional logic
const apiUrl = environment.production 
  ? 'https://api-guardify.abb-apps.com/api/v1'
  : '/api';  // Proxy in dev

// ❌ BAD: Hardcoded URLs
const apiUrl = 'https://api-devguardify.abb-apps.com/api/v1';
```

### 8.2 Proxy Configuration

```json
{
  "/api": {
    "target": "https://api-devguardify.abb-apps.com",
    "secure": false,
    "changeOrigin": true,
    "pathRewrite": {
      "^/api": "/api/v1"
    },
    "logLevel": "debug"
  }
}
```

### 8.3 Git Ignore Sensitive Configs

```bash
# .gitignore
proxy.conf.local.json
.env.local
```

### 8.4 Documentation

```markdown
## Running Development Server

### With Proxy (Recommended)
```bash
ng serve --proxy-config proxy.conf.json
```

### Without Proxy
```bash
ng serve
```

**Note:** Proxy is required for API calls to work without CORS issues.
```

---

## 9. Nx-Specific Configuration

### 9.1 Nx Serve with Proxy

```bash
# Serve with proxy
nx serve my-app --proxy-config proxy.conf.json

# Serve with specific configuration
nx serve my-app --configuration development
```

### 9.2 Nx Project Configuration

**project.json**:
```json
{
  "targets": {
    "serve": {
      "executor": "@angular-devkit/build-angular:dev-server",
      "options": {
        "browserTarget": "my-app:build",
        "proxyConfig": "proxy.conf.json"
      },
      "configurations": {
        "development": {
          "proxyConfig": "proxy.conf.dev.json"
        },
        "production": {
          "proxyConfig": "proxy.conf.prod.json"
        }
      }
    }
  }
}
```

---

## 10. Complete Example Setup

### Directory Structure
```
project/
├── proxy.conf.json
├── proxy.conf.dev.json
├── proxy.conf.prod.json
├── angular.json
├── src/
│   ├── environments/
│   │   ├── environment.ts
│   │   └── environment.prod.ts
│   ├── app/
│   │   ├── interceptors/
│   │   │   └── proxy.interceptor.ts
│   │   └── services/
│   │       └── api.service.ts
│   └── main.ts
└── package.json
```

### Quick Start

1. **Create proxy config**:
```bash
cp proxy.conf.json proxy.conf.dev.json
cp proxy.conf.json proxy.conf.prod.json
```

2. **Update `angular.json`**:
```json
{
  "serve": {
    "options": {
      "proxyConfig": "proxy.conf.json"
    }
  }
}
```

3. **Run development server**:
```bash
ng serve --proxy-config proxy.conf.json
```

4. **Make API calls**:
```typescript
// Uses proxy in development
this.http.get('/api/users')
```

---

## Summary

| Aspect | Development | Production |
|--------|-------------|-----------|
| **URL** | `/api` (proxy) | Full URL |
| **Config** | `proxy.conf.dev.json` | `proxy.conf.prod.json` |
| **CORS** | Handled by proxy | Handled by server |
| **SSL** | `secure: false` | `secure: true` |
| **Debugging** | `logLevel: debug` | `logLevel: error` |

This approach ensures clean separation between development and production environments while maintaining consistent API calls throughout your application.
