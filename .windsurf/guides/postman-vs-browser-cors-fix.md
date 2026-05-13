# Postman Success but Browser Fails - CORS & Proxy Troubleshooting

## Problem
- ✅ **Postman**: API calls work perfectly
- ❌ **Browser**: Same API calls fail with CORS errors or 404

## Root Causes

### 1. CORS (Cross-Origin Resource Sharing) Issue

**Why Postman works but browser doesn't:**
- Postman doesn't enforce CORS (it's a desktop app)
- Browsers enforce CORS for security
- Server must explicitly allow requests from your origin

### 2. Missing Proxy Configuration

**What happens:**
```
Postman:  POST https://api-devguardify.abb-apps.com/api/v1/users
          ✅ Works (direct request)

Browser:  POST https://api-devguardify.abb-apps.com/api/v1/users
          ❌ CORS Error (browser blocks it)
```

---

## Solution 1: Use Proxy (Recommended for Development)

### Step 1: Create Proxy Configuration

Create `proxy.conf.json` in project root:

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

### Step 2: Update `angular.json`

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

### Step 3: Update API Service

**Before (Direct URL - causes CORS):**
```typescript
export const environment = {
  apiUrl: 'https://api-devguardify.abb-apps.com/api/v1'
};

// In service
this.http.get(environment.apiUrl + '/users')  // ❌ CORS Error
```

**After (Using Proxy):**
```typescript
export const environment = {
  apiUrl: '/api'  // Uses proxy
};

// In service
this.http.get(environment.apiUrl + '/users')  // ✅ Works via proxy
```

### Step 4: Run with Proxy

```bash
ng serve --proxy-config proxy.conf.json
```

**Now browser requests:**
```
Browser:  GET http://localhost:4200/api/users
          ↓ (proxy redirects)
Server:   GET https://api-devguardify.abb-apps.com/api/v1/users
          ✅ Works!
```

---

## Solution 2: Server-Side CORS Headers (For Production)

If proxy isn't available, server must send CORS headers:

### What Server Should Return

```
Access-Control-Allow-Origin: https://your-domain.com
Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS
Access-Control-Allow-Headers: Content-Type, Authorization
Access-Control-Allow-Credentials: true
```

### Check if Server Sends CORS Headers

**In Browser DevTools:**

1. Open DevTools → Network tab
2. Make API request
3. Click the request
4. Go to "Response Headers"
5. Look for `Access-Control-Allow-Origin`

**If missing:**
```
❌ No CORS headers = Browser blocks request
```

**If present:**
```
✅ Access-Control-Allow-Origin: * = Browser allows request
```

---

## Solution 3: HTTP Interceptor with Proxy Detection

Create smart interceptor that uses proxy in dev, direct URL in prod:

```typescript
import { Injectable } from '@angular/core';
import { HttpInterceptor, HttpRequest, HttpHandler, HttpEvent } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../environments/environment';

@Injectable()
export class ApiInterceptor implements HttpInterceptor {
  intercept(req: HttpRequest<any>, next: HttpHandler): Observable<HttpEvent<any>> {
    // In development: use proxy
    if (!environment.production) {
      // If URL is absolute, convert to relative (for proxy)
      if (req.url.startsWith('https://')) {
        const path = req.url.replace('https://api-devguardify.abb-apps.com/api/v1', '/api');
        req = req.clone({ url: path });
      }
    }
    
    // Add headers
    req = req.clone({
      setHeaders: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${this.getToken()}`
      }
    });
    
    return next.handle(req);
  }

  private getToken(): string {
    return localStorage.getItem('token') || '';
  }
}
```

**Register in `app.module.ts`:**

```typescript
import { HTTP_INTERCEPTORS } from '@angular/common/http';

@NgModule({
  providers: [
    {
      provide: HTTP_INTERCEPTORS,
      useClass: ApiInterceptor,
      multi: true
    }
  ]
})
export class AppModule { }
```

---

## Debugging Checklist

### ✅ Step 1: Verify Postman Works

```
1. Open Postman
2. GET https://api-devguardify.abb-apps.com/api/v1/users
3. Add headers if needed (Authorization, etc.)
4. Click Send
5. ✅ Should see 200 response
```

### ✅ Step 2: Check Browser Network Tab

```
1. Open DevTools (F12)
2. Go to Network tab
3. Make same API call from browser
4. Look for error:
   - CORS error? → Use proxy
   - 404? → Check URL path
   - 401? → Check Authorization header
```

### ✅ Step 3: Check Proxy Configuration

```bash
# Verify proxy.conf.json exists
ls -la proxy.conf.json

# Check content
cat proxy.conf.json

# Verify angular.json has proxyConfig
cat angular.json | grep proxyConfig
```

### ✅ Step 4: Restart Dev Server

```bash
# Stop current server (Ctrl+C)
# Clear cache
rm -rf node_modules/.cache

# Start with proxy
ng serve --proxy-config proxy.conf.json
```

### ✅ Step 5: Check Console Logs

```typescript
// Add logging to see what URL is being called
this.http.get('/api/users').subscribe(
  (data) => {
    console.log('✅ Success:', data);
  },
  (error) => {
    console.error('❌ Error:', error);
    console.error('URL:', error.url);
    console.error('Status:', error.status);
  }
);
```

---

## Common Error Messages & Solutions

### Error 1: CORS Error

```
Access to XMLHttpRequest at 'https://api-devguardify.abb-apps.com/api/v1/users' 
from origin 'http://localhost:4200' has been blocked by CORS policy
```

**Solution:**
```json
{
  "/api": {
    "target": "https://api-devguardify.abb-apps.com",
    "changeOrigin": true,
    "pathRewrite": { "^/api": "/api/v1" }
  }
}
```

### Error 2: 404 Not Found

```
GET http://localhost:4200/api/users 404 (Not Found)
```

**Causes & Solutions:**
```typescript
// ❌ Wrong: Missing /api prefix
this.http.get('/users')

// ✅ Correct: Include /api prefix
this.http.get('/api/users')

// ✅ Or use environment variable
this.http.get(environment.apiUrl + '/users')
```

### Error 3: 401 Unauthorized

```
GET https://api-devguardify.abb-apps.com/api/v1/users 401 (Unauthorized)
```

**Solution:**
```typescript
// Add Authorization header
const headers = new HttpHeaders({
  'Authorization': `Bearer ${token}`
});

this.http.get('/api/users', { headers })
```

### Error 4: SSL Certificate Error

```
GET https://api-devguardify.abb-apps.com/api/v1/users 
SSL: CERTIFICATE_VERIFY_FAILED
```

**Solution in proxy.conf.json:**
```json
{
  "/api": {
    "target": "https://api-devguardify.abb-apps.com",
    "secure": false,  // ← Allow self-signed certificates
    "changeOrigin": true
  }
}
```

---

## Complete Working Example

### Directory Structure
```
project/
├── proxy.conf.json
├── angular.json
├── src/
│   ├── environments/
│   │   ├── environment.ts
│   │   └── environment.prod.ts
│   ├── app/
│   │   ├── interceptors/
│   │   │   └── api.interceptor.ts
│   │   ├── services/
│   │   │   └── api.service.ts
│   │   └── app.module.ts
│   └── main.ts
└── package.json
```

### proxy.conf.json
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

### environment.ts
```typescript
export const environment = {
  production: false,
  apiUrl: '/api'  // Uses proxy
};
```

### environment.prod.ts
```typescript
export const environment = {
  production: true,
  apiUrl: 'https://api-guardify.abb-apps.com/api/v1'  // Direct URL
};
```

### api.service.ts
```typescript
import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { environment } from '../environments/environment';

@Injectable({ providedIn: 'root' })
export class ApiService {
  constructor(private http: HttpClient) {}

  getUsers() {
    return this.http.get(`${environment.apiUrl}/users`);
  }

  createUser(data: any) {
    return this.http.post(`${environment.apiUrl}/users`, data);
  }
}
```

### app.module.ts
```typescript
import { NgModule } from '@angular/core';
import { HttpClientModule, HTTP_INTERCEPTORS } from '@angular/common/http';
import { ApiInterceptor } from './interceptors/api.interceptor';

@NgModule({
  imports: [HttpClientModule],
  providers: [
    {
      provide: HTTP_INTERCEPTORS,
      useClass: ApiInterceptor,
      multi: true
    }
  ]
})
export class AppModule { }
```

### Run Development Server
```bash
ng serve --proxy-config proxy.conf.json
```

---

## Quick Decision Tree

```
Does Postman work but browser doesn't?
│
├─ YES: CORS/Proxy issue
│  │
│  ├─ Using Angular/Nx?
│  │  └─ YES: Use proxy.conf.json (Recommended)
│  │
│  └─ Using other framework?
│     └─ Ask server team to add CORS headers
│
└─ NO: Check API endpoint, headers, authentication
```

---

## Summary Table

| Scenario | Postman | Browser | Solution |
|----------|---------|---------|----------|
| Direct URL, no CORS | ✅ Works | ❌ CORS Error | Use proxy |
| Direct URL, with CORS | ✅ Works | ✅ Works | No change needed |
| Proxy configured | ✅ Works | ✅ Works | Keep proxy |
| Wrong endpoint | ❌ 404 | ❌ 404 | Fix URL |
| Missing auth | ❌ 401 | ❌ 401 | Add token |

---

## Next Steps

1. **Create `proxy.conf.json`** with your API endpoint
2. **Update `angular.json`** to use proxy config
3. **Update `environment.ts`** to use `/api` instead of full URL
4. **Restart dev server** with `ng serve --proxy-config proxy.conf.json`
5. **Test in browser** - should now work like Postman

If still failing, check browser console for specific error message and refer to "Common Error Messages" section above.
